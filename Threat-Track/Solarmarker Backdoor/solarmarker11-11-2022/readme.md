### Decryption Method

```powershell
$A=New-Object System.Security.Cryptography.AesCryptoServiceProvider;
$A.Key=@([byte]136,73,144,47,247,21,226,78,180,232,213,236,64,96,75,124,93,169,166,96,59,183,0,9,92>
$A.IV=@([byte]146,129,15,39,90,248,116,78,170,149,152,187,185,81,42,108);
$F=[Convert]::FromBase64String([IO.File]::ReadAllText('<b64encodeddata>'));
$decrypted = $A.CreateDecryptor().TransformFinalBlock($F,0,$F.Length)
$A.Dispose(); [system.io.file]::writeallbytes("malicious.dll", $decrypted);
```

### shortcut

```
exiftool sample.lnk 
ExifTool Version Number         : 12.30
File Name                       : sample.lnk
Directory                       : .
File Size                       : 922 bytes
File Modification Date/Time     : 2022:11:11 15:57:50-05:00
File Access Date/Time           : 2022:11:11 15:58:14-05:00
File Inode Change Date/Time     : 2022:11:11 15:58:08-05:00
File Permissions                : -rw-rw-r--
File Type                       : LNK
File Type Extension             : lnk
MIME Type                       : application/octet-stream
Flags                           : IDList, LinkInfo, RelativePath, Unicode
File Attributes                 : Archive
Create Date                     : 2022:11:11 16:53:05-05:00
Access Date                     : 2022:11:11 16:53:05-05:00
Modify Date                     : 2022:11:11 16:53:05-05:00
Target File Size                : 868376
Icon Index                      : (none)
Run Window                      : Show Minimized No Activate
Hot Key                         : (none)
Drive Type                      : Fixed Disk
Volume Label                    : Windows
Local Base Path                 : C:\Users\Admin\WudymwJDoCjkbnXg.IXjCkhaNCPisIZdibgvJCLTkTK
Relative Path                   : ..\..\..\..\..\..\..\WudymwJDoCjkbnXg.IXjCkhaNCPisIZdibgvJCLTkTK
```

### Output
```
./malicious.dll
6ac3dc3f86c084c18f16fb8bac1278121952a270153438c344e7365fb89cafad
```
