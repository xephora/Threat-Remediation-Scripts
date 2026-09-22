#!/usr/bin/env python3
import argparse, hashlib, json, os, re, shlex, shutil, subprocess, sys
from datetime import datetime, timezone
from pathlib import Path

VERSION="1.0"; DEFAULT_ENUM_DIR="enum"
def run(cmd, outfile=None):
    cmd=[str(x) for x in cmd]; print("[+] "+" ".join(shlex.quote(x) for x in cmd))
    try: p=subprocess.run(cmd,text=True,capture_output=True,errors="replace")
    except Exception as e: p=type("R",(),{"returncode":127,"stdout":"","stderr":str(e)})()
    if outfile:
        q=Path(outfile); q.parent.mkdir(parents=True,exist_ok=True)
        q.write_text("$ "+" ".join(shlex.quote(x) for x in cmd)+f"\n[exit_code] {p.returncode}\n\n"+p.stdout+("\n[stderr]\n"+p.stderr if p.stderr else ""),encoding="utf-8",errors="replace")
    return p.returncode,p.stdout,p.stderr

def root():
    if os.geteuid()!=0: raise SystemExit(f"[-] Run with sudo: sudo python3 {Path(sys.argv[0]).name} ...")
def safe(s): return re.sub(r"[^A-Za-z0-9._-]+","_",Path(s).name)
def outdir_for(img):
    n=safe(img)
    for x in (".img",".dd",".raw"):
        if n.lower().endswith(x): n=n[:-len(x)]; break
    return Path(DEFAULT_ENUM_DIR).resolve()/(n or "disk")
def statefile(o): return o/".state.json"
def save_state(o,s): s["updated_utc"]=datetime.now(timezone.utc).isoformat(); statefile(o).write_text(json.dumps(s,indent=2)+"\n")
def load_state(o):
    try:return json.loads(statefile(o).read_text())
    except:return None

def existing_loop(img):
    r,o,_=run(["losetup","-j",str(img)])
    return next((x.split(":",1)[0] for x in o.splitlines() if ":" in x),None) if r==0 else None
def attach(img):
    x=existing_loop(img)
    if x: run(["losetup","-P",x]); return x,False
    r,o,e=run(["losetup","--find","--show","--read-only","--partscan",str(img)])
    if r or not o.strip(): raise RuntimeError(e.strip() or "losetup failed")
    return o.strip(),True
def children(loop):
    r,o,_=run(["lsblk","-ln","-o","PATH,TYPE",loop]); a=[]
    if r==0:
        for l in o.splitlines():
            f=l.split()
            if len(f)>1 and f[1]=="part": a.append(f[0])
    return a
def bv(dev,k):
    r,o,_=run(["blkid","-o","value","-s",k,dev]); return o.strip() if r==0 else ""
def pname(dev,loop):
    if dev==loop:return "whole_disk"
    b=Path(dev).name; l=Path(loop).name; t=b[len(l):] if b.startswith(l) else b
    return t if t.startswith("p") else b
def sha256(p):
    h=hashlib.sha256()
    with open(p,"rb") as f:
        for b in iter(lambda:f.read(8*1024*1024),b""):h.update(b)
    return h.hexdigest()
def mounted(path): return run(["findmnt","-n","--target",str(path)])[0]==0

def enum_global(img,loop,o,hashit):
    o.mkdir(parents=True,exist_ok=True); st=img.stat()
    (o/"image_info.txt").write_text(f"image={img}\nsize_bytes={st.st_size}\nloop_device={loop}\nenumerated_utc={datetime.now(timezone.utc).isoformat()}\n")
    if hashit:(o/"sha256.txt").write_text(f"{sha256(img)}  {img.name}\n")
    cmds=[("file.txt",["file","-s",img]),("fdisk.txt",["fdisk","-l",img]),("parted.txt",["parted","-s",img,"unit","s","print"]),("mmls.txt",["mmls",img]),("lsblk.txt",["lsblk","-a","-o","NAME,PATH,TYPE,SIZE,FSTYPE,FSVER,LABEL,UUID,PARTTYPE,PARTLABEL,MOUNTPOINTS",loop]),("blkid.txt",["blkid"])]
    for f,c in cmds:
        if shutil.which(str(c[0])):run(c,o/f)
        else:(o/f).write_text(f"[not installed] {c[0]}\n")
def enum_dev(dev,loop,p):
    p.mkdir(parents=True,exist_ok=True); fs=bv(dev,"TYPE"); uuid=bv(dev,"UUID"); label=bv(dev,"LABEL")
    (p/"filesystem.txt").write_text(f"device={dev}\nfilesystem={fs or 'unknown'}\nuuid={uuid}\nlabel={label}\n")
    for f,c in [("blkid.txt",["blkid","-p",dev]),("file.txt",["file","-s",dev]),("fsstat.txt",["fsstat",dev]),("fls_recursive.txt",["fls","-r",dev]),("fls_long.txt",["fls","-r","-l",dev]),("deleted_files.txt",["fls","-r","-d",dev]),("bodyfile.txt",["fls","-r","-m","/",dev])]:
        if shutil.which(c[0]):run(c,p/f)
    if shutil.which("mactime") and (p/"bodyfile.txt").exists():run(["mactime","-b",p/"bodyfile.txt","-d"],p/"timeline.csv")
    if fs in {"ext2","ext3","ext4"} and shutil.which("dumpe2fs"):run(["dumpe2fs","-h",dev],p/"dumpe2fs.txt")
    if fs in {"ntfs","ntfs3"} and shutil.which("ntfsinfo"):run(["ntfsinfo","-m",dev],p/"ntfsinfo.txt")
    return {"device":dev,"filesystem":fs or "unknown","uuid":uuid,"label":label}
def mount_opts(fs):
    if fs in {"ext2","ext3","ext4"}:return ["-o","ro,noload"]
    if fs=="xfs":return ["-o","ro,norecovery"]
    return ["-o","ro"]
def try_mount(dev,fs,mnt,log):
    if fs in {"swap","crypto_LUKS","LVM2_member","linux_raid_member","BitLocker"}:
        log.write_text(f"Skipped automatic mount: {fs}\n"); return False
    mnt.mkdir(parents=True,exist_ok=True); r,_,_=run(["mount"]+mount_opts(fs)+[dev,mnt],log)
    if r==0:print(f"    [+] Mounted READ-ONLY: {mnt}");return True
    try:mnt.rmdir()
    except:pass
    return False

def enumerate_image(img,o,do_mount,hashit):
    root(); img=Path(img).expanduser().resolve()
    if not img.is_file():raise SystemExit(f"[-] Image not found: {img}")
    o.mkdir(parents=True,exist_ok=True); loop=None; created=False; keep=False
    try:
        loop,created=attach(img); print(f"[+] Read-only loop device: {loop}"); enum_global(img,loop,o,hashit)
        parts=children(loop); devs=parts or [loop]; results=[]; mounts=[]
        if not parts:print("[!] No partitions detected; examining whole image as a filesystem.")
        for dev in devs:
            n=pname(dev,loop); p=o/n; print(f"\n[*] Enumerating {dev}"); info=enum_dev(dev,loop,p); info["name"]=n;results.append(info)
            if do_mount:
                m=o/"mounts"/n
                if try_mount(dev,info["filesystem"],m,p/"mount.txt"):mounts.append({"device":dev,"mountpoint":str(m),"filesystem":info["filesystem"]})
        (o/"partitions.json").write_text(json.dumps(results,indent=2)+"\n")
        if do_mount and mounts:
            keep=True;save_state(o,{"version":VERSION,"image":str(img),"loop_device":loop,"loop_created_by_diskenum":created,"mounts":mounts});print(f"[+] State: {statefile(o)}")
        print(f"[+] Enumeration complete: {o}")
    finally:
        if loop and created and not keep:run(["losetup","-d",loop])
def unmount_image(img,o):
    root();img=Path(img).expanduser().resolve();s=load_state(o)
    if not s:raise SystemExit(f"[-] No mount state found: {statefile(o)}")
    if Path(s.get("image","")).resolve()!=img:raise SystemExit("[-] State file belongs to a different image")
    for x in reversed(s.get("mounts",[])):
        m=x.get("mountpoint")
        if m and mounted(m):
            if run(["umount",m])[0]:raise SystemExit(f"[-] Failed to unmount {m}")
    loop=s.get("loop_device")
    if loop and Path(loop).exists():
        r,out,_=run(["lsblk","-ln","-o","MOUNTPOINTS",loop]); leftovers=[x.strip() for x in out.splitlines() if x.strip()]
        if leftovers:raise SystemExit("[-] Mounts remain; refusing loop detach: "+", ".join(leftovers))
        if run(["losetup","-d",loop])[0]:raise SystemExit(f"[-] Failed to detach {loop}")
    statefile(o).unlink(missing_ok=True);print("[+] Clean dismount complete.")
def status(img,o):
    root();img=Path(img).expanduser().resolve();s=load_state(o);print(f"[+] Image: {img}\n[+] Output: {o}")
    if s:
        print(f"[+] Loop: {s.get('loop_device')}")
        for x in s.get("mounts",[]):print(f"    {x.get('device')} -> {x.get('mountpoint')} [{'mounted' if mounted(x.get('mountpoint')) else 'not mounted'}]")
    else:print("[-] No saved mount state.")
    x=existing_loop(img);print(f"[+] Current loop attachment: {x}" if x else "[-] Image is not attached.")
    if x:run(["lsblk","-o","NAME,PATH,TYPE,SIZE,FSTYPE,MOUNTPOINTS",x])
def main():
    ap=argparse.ArgumentParser(description="Enumerate raw DD/IMG images; optionally mount filesystems read-only.")
    ap.add_argument("image");ap.add_argument("-o","--output")
    g=ap.add_mutually_exclusive_group();g.add_argument("--mount",action="store_true");g.add_argument("--unmount","--dismount",dest="unmount",action="store_true");g.add_argument("--status",action="store_true")
    ap.add_argument("--no-hash",action="store_true");a=ap.parse_args();img=Path(a.image).expanduser().resolve();o=Path(a.output).expanduser().resolve() if a.output else outdir_for(img)
    if a.unmount:unmount_image(img,o)
    elif a.status:status(img,o)
    else:enumerate_image(img,o,a.mount,not a.no_hash)
if __name__=="__main__":main()
