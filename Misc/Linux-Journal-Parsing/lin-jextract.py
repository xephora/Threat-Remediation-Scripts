#!/usr/bin/env python3

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


def run(cmd, check=True):
    print("[+] " + " ".join(map(str, cmd)))
    result = subprocess.run(
        [str(x) for x in cmd],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    if check and result.returncode != 0:
        if result.stderr:
            print(result.stderr.strip(), file=sys.stderr)
        raise RuntimeError(
            f"Command failed ({result.returncode}): "
            + " ".join(map(str, cmd))
        )

    return result


def require_root():
    if os.geteuid() != 0:
        print(f"[-] Run with sudo:")
        print(f"    sudo python3 {sys.argv[0]} <image>")
        sys.exit(1)


def require_tools():
    tools = [
        "losetup",
        "lsblk",
        "blkid",
        "dumpe2fs",
        "debugfs",
    ]

    missing = [x for x in tools if shutil.which(x) is None]

    if missing:
        print("[-] Missing required tools:")
        for tool in missing:
            print(f"    {tool}")
        sys.exit(1)


def attach_image(image):
    result = run([
        "losetup",
        "--find",
        "--show",
        "--read-only",
        "--partscan",
        image
    ])

    loopdev = result.stdout.strip()

    if not loopdev:
        raise RuntimeError("losetup did not return a loop device")

    return loopdev


def get_partitions(loopdev):
    """
    Return child partitions belonging to the loop device.
    """

    result = run([
        "lsblk",
        "-ln",
        "-o",
        "PATH,TYPE",
        loopdev
    ])

    partitions = []

    for line in result.stdout.splitlines():
        fields = line.split()

        if len(fields) < 2:
            continue

        path, devtype = fields[0], fields[1]

        if devtype == "part":
            partitions.append(path)

    return partitions


def detect_filesystem(device):
    """
    Ask blkid directly instead of trusting lsblk's FSTYPE.
    """

    result = run([
        "blkid",
        "-o",
        "value",
        "-s",
        "TYPE",
        device
    ], check=False)

    return result.stdout.strip()


def get_journal_inode(device):
    """
    Extract Journal inode from dumpe2fs.
    """

    result = run([
        "dumpe2fs",
        "-h",
        device
    ], check=False)

    output = result.stdout + result.stderr

    match = re.search(
        r"Journal inode:\s*(\d+)",
        output,
        re.IGNORECASE
    )

    if not match:
        return None

    return int(match.group(1))


def dump_journal(device, inode, outfile):
    """
    Dump the internal EXT journal using debugfs.
    """

    outfile = Path(outfile).resolve()

    command = f"dump <{inode}> {outfile}"

    result = run([
        "debugfs",
        "-R",
        command,
        device
    ], check=False)

    # debugfs sometimes prints normal informational
    # messages to stderr, so don't rely solely on stderr.

    if not outfile.exists():
        print(f"    [-] Journal dump was not created.")

        if result.stderr:
            print(result.stderr.strip())

        return False

    if outfile.stat().st_size == 0:
        print(f"    [-] Journal dump is empty.")
        return False

    return True


def dump_journal_log(device, outfile):
    """
    Save debugfs journal transaction listing.
    """

    outfile = Path(outfile).resolve()

    result = run([
        "debugfs",
        "-R",
        "logdump",
        device
    ], check=False)

    # debugfs may use both stdout and stderr
    data = result.stdout + result.stderr

    outfile.write_text(
        data,
        encoding="utf-8",
        errors="replace"
    )


def main():
    parser = argparse.ArgumentParser(
        description=(
            "Automatically extract EXT3/EXT4 journals "
            "from a forensic disk image."
        )
    )

    parser.add_argument(
        "image",
        help="Disk image to examine"
    )

    parser.add_argument(
        "-o",
        "--output",
        default="journal_output",
        help="Output directory (default: journal_output)"
    )

    args = parser.parse_args()

    require_root()
    require_tools()

    image = Path(args.image).resolve()

    if not image.exists():
        print(f"[-] Image does not exist: {image}")
        sys.exit(1)

    output_dir = Path(args.output).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    loopdev = None

    try:
        print(f"[+] Image: {image}")

        loopdev = attach_image(str(image))

        print(f"[+] Read-only loop device: {loopdev}")

        partitions = get_partitions(loopdev)

        if not partitions:
            print("[!] No partitions detected.")
            print("[!] Checking whole loop device instead.")
            partitions = [loopdev]

        found = 0

        for device in partitions:

            print()
            print(f"[*] Examining {device}")

            fstype = detect_filesystem(device)

            if fstype:
                print(f"    Filesystem: {fstype}")
            else:
                print("    Filesystem: unknown")

            if fstype not in ("ext3", "ext4"):
                print("    [-] Not a journaled EXT filesystem")
                continue

            journal_inode = get_journal_inode(device)

            if journal_inode is None:
                print("    [-] No internal journal inode found")
                continue

            print(f"    [+] Journal inode: {journal_inode}")

            name = Path(device).name

            journal_file = (
                output_dir /
                f"{name}_journal.bin"
            )

            log_file = (
                output_dir /
                f"{name}_journal_log.txt"
            )

            print(
                f"    [+] Dumping journal inode "
                f"<{journal_inode}>..."
            )

            if dump_journal(
                device,
                journal_inode,
                journal_file
            ):
                found += 1

                size = journal_file.stat().st_size

                print(
                    f"    [+] Journal dumped successfully"
                )
                print(
                    f"    [+] Output: {journal_file}"
                )
                print(
                    f"    [+] Size: {size:,} bytes"
                )

                print(
                    f"    [+] Creating journal transaction log..."
                )

                dump_journal_log(
                    device,
                    log_file
                )

                print(
                    f"    [+] Log: {log_file}"
                )

        print()

        if found:
            print(
                f"[+] Finished: extracted "
                f"{found} EXT journal(s)"
            )
        else:
            print(
                "[-] No EXT journals were extracted."
            )

    finally:

        if loopdev:
            print(f"[+] Detaching {loopdev}")

            subprocess.run([
                "losetup",
                "-d",
                loopdev
            ])


if __name__ == "__main__":
    main()
