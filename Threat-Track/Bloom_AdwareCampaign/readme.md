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

`C:\Users\Admin\Downloads\Your File Is Ready To Download.iso`

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

### Observed Hashes for ISOs => Your File Is Ready To Download.iso

Average File Size: 125M

```
52ea2d8221221b27c7199bcef13a40f5ee924074454a387ff421d33c781325b4
```

### Observed Hashes for Energy

```
b0d08001dae59d15b3158e2535e3251dcf9d506d4f24ecc9a4d4b8f2c20a88c2
847e59791a8eda177cc2a91784211891b4cdfacdb322d3971cd0a56c065b7161
c9b7c7b2ebad37c8147cd46d142ca6ab49ad8aded1f72815a2d07da2ec72aceb
1419f3710164cc6e699da56e3808cf4e6b66c29e31e034c00538e3553fb54ca8
f6e62d36d3d8b416a8e261b8e84a6129717c9e10aea91bd457a1c5c8ffa086a4
f7b654e92954c02d2235390a19885609b9aef3b1259cd36be5e003f264dcdd51
efe2d15dc89018fa80097dfb70c94b72ff625fa73a0c0e3b75b3a66a72b22bda
b3c8c4c1fd720a7ad7d86d56a22adb794db16cbc48ffcc59e511999febdf7f21
554900329d157c8e2d504fa4aea97e21d78c82da2f61cf413ee53f28b39412da
20251ce46063095c00b92b8753ac51d28be0c80ed1b93ea66c129de5ea8b3a98
fd36480ed1b66d4efbda6927cdea94991df8feb5f9428d9d43474164861e0ede
8b3a20ab2797a481f6b36f9909c3d6255cb77a1d2a663382f30e08fec8fe2164
cdb9021286d609b563519007d8487e6b1ef31fb63ebc3d603bbe412ac49d8b45
999c4851a6bc1914883ce78f85df43e74545e92449e04b369873907da378ec27
52cbbbbe868f6c1aa2bfd6692f3bbf37005d5ecf3ceceef6de19052cc129e916
e125bed0be8845e661fcdf3f1056c1fd964d78855d3995fe85711fb42d1f6055
a48707c8bccfc5359fc6d53d0ff62cb77b4d5f5c60e77d2b9eb309c459ecd1bf
f0284e8aa1eb6fd234b9992ec34c95130de46e3b9e449643823c51ab76f5bd85
6d7119a4137b8955da2c70298defa3005a6fe37aff3bd35d415ac1eaf46f9b5b
f752d4ffba20a448153ed6226d8a269bc3d867dd6ba9a00408d88857c9c3b3fc
3272a53a40cb799cdebf292ca77d7f857399ab59832923916ea7cd0b9d123022
0bb215c9a4ad596213f754bf911786b71c011389f47f16d931ff173e5c336b09
b39b3721b487b36d7b418a8a4a4aced90cbbb0f44d45ed7d036c1ab500f26074
76010da78491c09cf9470c56a057e170ab5f7c87f7d04efe993c661402997814
a53b3cc5fafc0d3d37306ad105f0f96194139e79d970b5fe06ca6468e63a86ab
37ca1d0a2ebd8c7a8269c724521dcc86123da1a9c9c8215326d420ec977c69ba
1f08c504ef2cfa7c897e9644ddfd32c3def4385918f0119b9a08ef84a91502fc
979b74ce03dd68c90ba54b5090b3e91eef4ec2652d7d50f04c034de6802c8355
20184ffa271beb9fe194413990c0f6622cbbc6ab84df2f44d5c7becd45cc8499
89acd9146f6de688d7e670a93c936da41b3741dc8c65771f0321bf94362a4749
f636b2692ab51c81c04bc4b92a2fadb3c5a62966de47b01ec4ed4187ad683ecf
ce012736f7579faa280ffdc05284431e86c3e11ff8b27a0bf31a1826ad7bad81
415a9c8b04fac0502d5f4b18c308960aca10cb44f1633fb2fa526cb1480e3ba2
a70648fbc15ecf546ead65fda7f7cd28dc5313f8bf99e215ee84e30bcea70a09
7dce4de72f5916efd5efc2343fb5b23953ec3b8fdd3dbfa071f1e7d6100565af
```

### Observed Hashes for Prime

```
2612c29592e3f85d44a19f91124bd252e4d582776bd62ab3a9d9b0a4659bc5f9
d62bf2d60f7fee67960026a1d3b17bea59f9a564688ae215f6a57949a4e9fc99
f9c70719db50981a17fdb1429402256d5a519abed81fd4101506393f61a2e534
3a72dc42d5996f84cb56db1734f7170aa96bded39f97c9e4a04938aa613f5fc7
cdfe0b9698822cb53205caace5725675ddc3eaaa66db0c9aa3a1e0ed78815f3e
d2a736146583d41dffd920626ac59173c9d8284758ad9062acf516e2917e0d91
a04110396456398d02e12cf2bed3418fbdd8995ca8f4d00aafd0795a41f33285
a462b86c685e9bc6c06b5dadc1348a6d868ffc3d961ee841498edd656ae1a9fc
```

### Observed Hashes for Tone

```
e115876e90390b11ffe54318516044724c0561fec5eb5bb5e04ecffad216605b
777b6cd95b5c25d89ba7e8314408ad1a7bdef415c435248047bac3b1fba634ae
3fa5a4aec0353e1066ca55bbe34d03fe417ae0b5035a5dc072e0541c44fff31d
0648a709452c1dda1dfdae6c434189b1bbf6c9e8ab62e30b4c18d4441aec198f
ce8bb49a19089ee6445513a00e93ad00c9f155a5499af93e8caa5927ef8af8e3
0cf851ad3911dba993b311bc47cc26d1992a4de81557cd3455b5b1db2e9ac518
3e363cb716b8fdfbd947cc652d38897762ce025816c3a8c905211bd0cf54b69f
7266dd5ec5b7fe13905333c3b18ad82fa0a6bfb8d1e486f368cc173f45add863
f9cdf48e9e639d39ad3342e51fa35f63708449106f71f9719e176d5fdff6bd7b
6a0fa055fddf9a13a970bb45c059b9236158c64214edc6661591e35bcb255cb1
0c3196f59d6082fe06cac9aeba4ebcaa6011f4c1b982eb7a7c2503872af08c4a
4a1010e53937728e52bf1d8d232121b8a564dd46353d68ccfec94f3374b1e6c5
bd077a44537c59c4d9384c231f05267dc8ed52ce984a9ec4eec3a1810e1b45e3
60f8442535677cd630b4eef4a5d1d472b35124f9664cf68ca26cf423483e6f9f
3602e1c282496986172079da1b8a95275c8f1e2d75f8693f351a786a3c334321
47057fa0c46aa9e049781c053d6f9f3cd6419ee188683d08cb95f77cb239f380
3c6a3d27318e535391a78064a32ad44d7bba316e9de9bd7f724c768a953cbd0f
a2f76587821d8f2225b102f6a40c94d2060ec421e6a45b9f65121c09c56d6aae
6da89db7279967088acf49eee18902baec6ac6c67e89bd73ac250d34648a5e4e
d47b5491fe3423684aa66b0b350dabdd8fc22e37594a6d3ff19940f910e104c9
220788e9c8572df75a7ea2124a2791f106f26aa45a63f7b8992337407a4c0a39
8e56fd8fdf8d68bf6452630249c8d86805150f9ba2a5419fab948ff01c50cff2
3c484b7e903c948c80931a5ad717de14f3fdb039f65d36a73cbf1033055b9ded
666f21e47066e2066c384b845a3a46e8eda17e32da4dcce11333a070baf94573
7e3d806bc74129581b38e9c927bcfd9a1bab889ec64b68834bc1d00e473fa646
2684043ac534b8df7182c73c6467e2aa8dd056e2596fea03ae9dcceab715b2c5
6b10d94f5f0a27806c24ba3980595155320b5e91ad79e35df5298e5d5cdefe76
0e960aea482b80e7b0caa24006d2bdddc0dfce740189fb8026db4ffe26b49343
6f2e9b63c8664528a3d577fee02e5c7235ffa84e2e3f89262b1e781c1bd86606
```

### Observed hashes for Bloom

```
90424e0d475ea4851ea934d8d20cc81bad212389b024697df210587704720c65
8d7f4c11f5952bc2d92bb64ef7697be2cb496f63bee8a36b275bc5594d728faa
6a071651ffc3803db1c31051db553429f1e3c711a99650923adb881186b74030
5cc89197b777bbaceded428117db5599679cc6e322a2c6f107a9670a1996239c
1163d74214ac82365be2bd28ff91918af7b92daab62da4fbf7ff906e8160d83f
ed3c19ebfb85d5c053c3e97a8ccaa3477aba32d8c6548fbb7b7bfc6313a2577c
a94d7bd02d3ee7bbbfc8c223fa1dff152283796d042dfa74dd4ecee971c2d0cf
4cac14a0818b01b45efef3e67ac27502244ecb72e7f71f3df90bd83332343da4
074e53af99346bf7fe2f60be5735513e15eab668de6beed224f9d2c39ee67d75
c58146cdf87d074aff3f523f30fab994b1371fbd946184b1bac6f7aa18f3c7fa
05045733ada686a92c8c97633f814c367a281e00e7b17766441230d7a6973882
961eacc9bbdec4078cb04bd349f24eafe3d331bf4a82d25c0c2b50a1b9c3f150
5994bd1c7988c2fb3c821dab3676c9e03cffc3f85501a23843f5048dfeedfe09
41d07d30b32c85c65b2aba9bc4218d030a5d66915032fd47535be82534e64e81
6ee8be5238912c4ceb03646cc70a3b53a61dedd32ab4735a408ac24a653b44ef
1e8f2e490c717718eb87eb5536b46929de4136e040eca76f039ab4c5ef3f8c04
7749b7b2826ddc9864637c9b73ae2ce963f7540de78df2ce5b8324c83129aea2
ffd8624eb47140c4e7f66ef46101aead8b41592dbc1dd85e286b21888179ce05
e0a118d4194557e96259f39c71698e0cf18cc4d64af68f5195562ec2a474101f
86305fced980dd2b10d9279c32f05c4bdd2323d8d31e6f1196a9bf8acf601b80
0c3798df2d220d9dc01eca702886b8650cbbc8941efb06bd723c109a592ff910
36cff29bbe4a81a77e9d573ff75736c340653c3d031b26bfb1b4297ebc78dcf3
5a75589cd61deafebd31d055a8aa8bf8dc6f1cc4871b28b334c100da37218449
b75e925136cd3b0bd9c8b9517253d2d47812896b4c36739f0965db51cb93807c
86fb82a4b5697ae47763b92fc40b3454cc92de82ef95103c0fbd92fe4a53ccff
41c50c32fcbd7dbdc832142ba87c77e2fee9bb046e1ec7c35b7bf3db50d9a896
6e247d64a5f35c01d96fd4502cc657aa36107b6f022acb6e36b54dfa0b93cc9e
3dfc85c75166a54ec1978029de23c8ba2e1bf9193bc3b7180fd65f5271fc1190
6b71dd2b8c20f2365cd0cae40558bf93a9b9edd9c2dd06ce6d61005c707548ab
ada1e25acbaaf7b101986a70baf57b9a3b2786e62aed3f165c25cd6c6877d69d
30c9179a776ed0e5e9f9ce2fab31286fa06d07cdd67bbd5f43d9dc0084b632bd
e84adf501260df339df9a12b2de6d98925acac9ee32247925c0e4915a27d6744
a2755dbf3c99e2ab3a6de18855d47ff80fe63a6ff087f20ff393566f09872f9e
72b551c79f6cc0a6ad7823eb232205f0075911c192f4d89d5194cb165ec9af58
421203439fe3a8e4758026f7d8c3249c0b8b027a6b7f5d67699ee6a1ce1425c4
62e8c32966a30afa264f0477a412f30fdd79bb52e42a34079bca9d0374ffa229
88e72b679536ac6c85e4cbf1172cbcb6005897dc725cca7a606efac37d55898f
d0e1b5653296c0c82a41bd02fd350dd07fc2ae7b4d3723fcf610a386c16ec568
```

### Observed hashes for Strength

```
5efffbec7d018fc9b1ab4321e01059a6ad6aa32c714d6cce3dd8f56c29a210fa
```

### Observed hashes for Healthy

```
6048af8ea002d26ab6a5ca1b56c7c2c49546f2d5e7e40fb05d47b82f6344a6c9
6817325e52469d0c2a18f80751cc7d22b2912317ac4f2ee0c6b820aba310ad71
769949535390d4314e3e8724992238cb06feb260d875ab342e7ac73b6ea7ba92
a435384f966ba6f3c19b437dc31926908325be7c64ad98d83ceb7a55856c3369
c54436c7c11e8eaf4c47e94830ff4d8ba057a86840ac7591a1d8e00d7eb1b2a5
909d3083d4787949d280077324c58adc008d045ef470527b3ce97fbaea103b9a
```
