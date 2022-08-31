**long inhale of breath.......**
# Observed IOCs of Adware campaign Bloom aka Tone aka Prime aka Energy aka Strength aka Healthy...
**Exhales.......**

### Description

Yes, this post is quite late! I did not see much information regarding this adware campaign and I decided to share my findings.  My findings were specifically for Energy adware.  However, if you notice, most instances of these iterations of adware behave similar in nature, the only difference ^really is the name of the adware and sometimes delivery mechanism (explained below).

### First observed?

I began noticing events as early as May 1st, 2022.

###  What are these pesky adware and how do they work?

The adware appears to be distributed similarly to ChoziosiLoader, where a victim visits a website serving malvertisement.  The victim is then lured into downloading an iso file to disk.  When the iso file executes, the iso mounts like a CD/DVD.  The contents of the disk image is read-only and cannot be removed by a local antivirus unless the iso is dismounted which makes the delivery mechanism effective.  The payload delivery has evolved overtime, initially started as a simple setup installation file, but now the adware takes advantage of Windows shortcut file (lnk) to execute a batch script.  Once the batch script executes, the adware is decompressed and implanted on the victim's computer serving Ads.  Persistence is set via a registry key.

### Dynamic Analysis

https://tria.ge/220831-blxemagdc5/behavioral1

### Why are they being distributed?

Simply put, similar to ChoziosiLoader, it appears that the intentions of the Adware campaign is to gain Ad revenue by forcing victims to run Ads without their consent.

### What have I learned from this adware?

The user initially visits a website that serves malvertisement, which entices the user into downloading an iso file named "Your File Is Ready To Download.iso".

`C:\Users\profilename\Downloads\Your File Is Ready To Download.iso`

Decompressing the iso file, you can see a zipped archive containing the adware named `app.zip` along with the delivery mechanism (the shortcut).

```
ls -lt
total 127236
-rw-rw-r-- 1 remnux remnux 130272295 Jun 22 02:00 app.zip
-rw-rw-r-- 1 remnux remnux      1179 Jun 22 00:52 Install.lnk
-rw-rw-r-- 1 remnux remnux       302 Jun 22 00:52 resources.bat
-rw-rw-r-- 1 remnux remnux      4286 Jan 25  2022 icon.ico
```

Retrieving the hashes

```
sha256sum *
37c049e9ebb69972275505f647f2704531f87c0600344e99eb9310967d540cc5  app.zip
28aa9e1138699400262d57ff33a1f8527c19aac9def50ae346f735aedb6f362e  icon.ico
2f00d7cd954bcb1fffdc3f14fde7f239b4eb3aecc9f6ac24540ed25856969f33  Install.lnk
9a143b794c66645c16182effad66d62593250e713da0a7b68a510cb6e5fa13f3  resources.bat
```

Analyzing the shortcut (Install.lnk), using a tool named exiftool to inspect the metadata of the shortcut, you can see that the "Relative Path" contains the path to the batch script.  Yes, even though there are a large number a traversed directories, the shortcut will ultimately run `resources.bat` in the directory of where the shortcut resides.

```
exiftool Install.lnk
ExifTool Version Number         : 12.30
File Name                       : Install.lnk
Directory                       : .
File Size                       : 1179 bytes
File Modification Date/Time     : 2022:06:22 00:52:05-04:00
File Access Date/Time           : 2022:08:30 20:16:26-04:00
File Inode Change Date/Time     : 2022:08:30 20:15:02-04:00
File Permissions                : -rw-rw-r--
File Type                       : LNK
File Type Extension             : lnk
MIME Type                       : application/octet-stream
Flags                           : IDList, RelativePath, IconFile, Unicode, ExpIcon
File Attributes                 : (none)
Target File Size                : 0
Icon Index                      : 81
Run Window                      : Show Minimized No Activate
Hot Key                         : (none)
Target File DOS Name            : resources.bat
Relative Path                   : ..\..\..\..\..\..\..\..\..\..\..\resources.bat
Icon File Name                  : C:\Windows\System32\SHELL32.dll
```

The batch script uses tar to decompress the adware contained in the zipped archive and copies it to `%APPDATA%` which is an environmental variable that points to `C:\users\victim\AppData\Roaming`.  A registry key is also created for persistence.  Finally, a call to `Energy.exe` file is made running the adware.

```
tar -xvf "app.zip" -C "%APPDATA%"
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v Energy /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v Energy /t REG_SZ /d "%APPDATA%\Energy\Energy.exe --fTZuKpU" /f
start /d "%APPDATA%\Energy" Energy.exe
```

Inspecting the adware directory.

```
ls Energy/
d3dcompiler_47.dll  Energy.exe  ffmpeg.dll  icudtl.dat  imgs  libEGL.dll  libGLESv2.dll  locales  node.dll  nw_100_percent.pak  nw_200_percent.pak  nw.dll  nw_elf.dll  resources.pak  v8_context_snapshot.bin
```

Retrieving th hashes

```
sha256sum *
44422e6936dc72b7ac5ed16bb8bcae164b7554513e52efb66a3e942cec328a47  d3dcompiler_47.dll
20184ffa271beb9fe194413990c0f6622cbbc6ab84df2f44d5c7becd45cc8499  Energy.exe
09385bebc5b187013f61eadbbd78cc3ce57450f817ac015f80eeec088487e1a4  ffmpeg.dll
27993e2079711d5f0f04a72f48fee88b269604c8e3fbdf50a7f7bb3f5bfc8d8e  icudtl.dat
2808219d604965abf74b4de1d1e6d963d1852137c09e35c63360bb83443e6295  libEGL.dll
eb22c1d16db8e23270b444c7a021ba65331fa7b456fd911f3133599bddd42189  libGLESv2.dll
1dbcedce8511415b0caed26619f487b608205eeff8f66be62b7f608807c12861  node.dll
56a6c7a68080ee8f7a21caa8a47d73d0cb37938ee309063fdf106a14601500da  nw_100_percent.pak
28473b4ac38998d51371a3778d04311ced25f4c52789b4dcd7aaeae5b8e93f1f  nw_200_percent.pak
cf90329ee59df8fbeb76e326b401c0cd9cfc6e103597aeb8377b773e1407548a  nw.dll
51cd730f33682a99410117cdac984f2e1ea21f7c8af113b0e830532e9849b316  nw_elf.dll
cc349228353eda27746a27961c38d4e259d45cf289e95b859e9a9149293c84e0  resources.pak
d52434371714364d51f5ef4c16e707ab2f834d74edf9d74d00a94e8873c2d5e8  v8_context_snapshot.bin
```

### Execution

The adware launches as an instance of Chromium.

```
Energy.exe --type=crashpad-handler "--user-data-dir=C:\Users\Admin\AppData\Local\Energy\User Data" /prefetch:7 --monitor-self --monitor-self-argument=--type=crashpad-handler "--monitor-self-argument=--user-data-dir=C:\Users\Admin\AppData\Local\Energy\User Data" --monitor-self-argument=/prefetch:7 --monitor-self-annotation=ptype=crashpad-handler "--database=C:\Users\Admin\AppData\Local\Energy\User Data\Crashpad" "--metrics-dir=C:\Users\Admin\AppData\Local\Energy\User Data" --annotation=plat=Win64 --annotation=prod=Energy --annotation=ver=0.0.2 --initial-client-data=0x144,0x148,0x14c,0x118,0x150,0x7fef6a09ec0,0x7fef6a09ed0,0x7fef6a09ee0

Energy.exe --type=renderer --no-sandbox --file-url-path-alias="/gen=C:\Users\Admin\Desktop\New folder\Energy\gen" --js-flags=--expose-gc --no-zygote --register-pepper-plugins=widevinecdmadapter.dll;application/x-ppapi-widevine-cdm --field-trial-handle=1128,10788128275247529521,6286875688596497083,131072 --lang=en-US --user-data-dir="C:\Users\Admin\AppData\Local\Energy\User Data" --nwapp-path="C:\Users\Admin\AppData\Local\Temp\nw996_83271666" --nwjs --extension-process --enable-auto-reload --ppapi-flash-path=pepflashplayer.dll --ppapi-flash-version=32.0.0.223 --device-scale-factor=1 --num-raster-threads=1 --renderer-client-id=5 --mojo-platform-channel-handle=1724 /prefetch:
```

### References to a plugin contained in "Energy.exe"

```
package.json{"name":"Energy","version":"0.0.2","description":"Simple app for your simple purposes","main":"open.html","single-instance":true,"nodejs":true,"private":true,"kan_is_watcher":false,"dependencies":{"axios":"^0
.20.0","geoip-lite":"^1.4.2","moment":"^2.29.0","os-utils":"0.0.14","systeminformation":"^5.0.2","universal-analytics":"^0.4.23","weather-js":"^2.0.0"},"window":{"icon":"./imgs/appIcon.png","title":"Energy","show":false,"frame":false,"toolbar":false,"width":30
0,"height":47,"min_height":47,"min_width":300,"position":"center"},"webview":{"partitions":[{"name":"trusted","accessible_resources":["<all_urls>"]}]},"webkit":{"plugin":true},"chromium-args":"--ppapi-flash-path=pepflashplayer.dll --ppapi-flash-version=32.0.0.
223 --enable-widevine-cdm --register-pepper-plugins=widevinecdmadapter.dll;application/x-ppapi-widevine-cdm --widevine-cdm-path=widevinecdmadapter.dll --widevine-cdm-version=1.4.9.1088","js-flags":"--expose-gc"}
```

### Ads injected into Chromium

A few of the sites referenced in "Energy.exe"
```
https://sed.am
https://mkrtchyan.ga
https://didiserver.herokuapp.com/pappk
http://blog.izs.me
http://bluesmoon.info
http://compton.nu
http://cr.yp.to
http://ed25519.cr.yp.to
http://eev.ee
http://jes.st
http://mathiasbynens.be
http://new.gramota.ru
http://nacl.cr.yp.to
http://r.va.gg
http://www8.plala.or.jp
http://www.bitstorm.it
http://versionbadg.es
http://rocha.la
http://bit.ly/900913 => http://www.alideas.com/
```
