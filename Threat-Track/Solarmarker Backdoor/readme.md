### SolarMarker Backdoor Generator of redirectors

### deobf methods for c2 server

Solarmarker Decryption method (06-06-2022)
```powershell
$AC=New-Object System.Security.Cryptography.AesCryptoServiceProvider;
$AC.Key=[Convert]::FromBase64String('SjQDQJXpF0XycaMaRqevDN2rb/N/xhU/qpHAQAoW3lk=');
$EB=[Convert]::FromBase64String([IO.File]::ReadAllText("<PathToFile>"));
$AC.IV = $EB[0..15];
$Decryptor=$AC.CreateDecryptor();
$UB=$Decryptor.TransformFinalBlock($EB, 16, $EB.Length-16);
$AC.Dispose(); [system.io.file]::writeallbytes("output.dll", $UB);
```

string char array

```python
def getaddr():
    arg = ""
    num = 62065
    arg += chr(num - 61961)
    num2 = 93773
    arg += chr(num2 - 93657)
    num3 = 41221
    arg += chr(num3 - 41105)
    num4 = 63524
    arg += chr(num4 - 63412)
    num5 = 64570
    arg += chr(num5 - 64512)
    num6 = 64983
    arg += chr(num6 - 64936)
    num7 = 15495
    arg += chr(num7 - 15448)
    num8 = 98849
    arg += chr(num8 - 98800)
    num9 = 92952
    arg += chr(num9 - 92900)
    num10 = 58141
    arg += chr(num10 - 58087)
    num11 = 38935
    arg += chr(num11 - 38889)
    num12 = 69505
    arg += chr(num12 - 69450)
    num13 = 18834
    arg += chr(num13 - 18786)
    num14 = 34330
    arg += chr(num14 - 34284)
    num15 = 91560
    arg += chr(num15 - 91504)
    num16 = 38845
    arg += chr(num16 - 38796)
    num17 = 21635
    arg += chr(num17 - 21589)
    num18 = 91294
    arg += chr(num18 - 91238)
    num19 = 73750
    return arg + chr(num19 - 73700)

if __name__ == "__main__":
    print(getaddr())
```

Byte array

```python
byarray1 = bytearray([144,62,97,39,210,180,234,230,205,111,185,116,83,64,194,17,94,173,162])
byarray2 = bytearray([248,74,21,87,232,155,197,215,249,89,151,67,99,110,250,33,112,148,146])

for i in range(19):

    byarray1[i] = byarray1[i] ^ byarray2[i]

print(f"C2 Server: {byarray1.decode()}")
```

### URL generators

Generate a list of `1000` Solarmarker Backdoor redirectors for the purpose of blocking.  If the compromised site is taken down and if you find a different compromised site you can replace the site below with yours.

```python
import requests

def GenerateList(url):
        UList = []
        with open("urllist.txt", "w") as f:
                for i in range(1000): # 1000 requests can be changed to whatever amount you want.
                        resp = requests.get(url, allow_redirects=True)
                        genUrl = resp.text.split(";URL=")[1].split("\">")[0]
                        print(genUrl)
                        f.writelines(genUrl+"\n")
                        UList += genUrl

if __name__ == '__main__':
        url = "https://overadmit.site/Earthquakes-And-Seismic-Waves-Worksheet-Pearson-Education/pdf/sitedomen/8"
        print(GenerateList(url))
```

You can also supply a url as an argument as well. Example: Python3 GenerateList.py `https://somebadwebsite.site/Earthquakes-And-Seismic-Waves-Worksheet-Pearson-Education/pdf/sitedomen/8`

```python
import requests
import sys

def GenerateList(url):
        UList = []
        with open("urllist.txt", "w") as f:
                for i in range(1000):
                        resp = requests.get(url, allow_redirects=True)
                        genUrl = resp.text.split(";URL=")[1].split("\">")[0]
                        print(genUrl)
                        f.writelines(genUrl+"\n")
                        UList += genUrl

if __name__ == '__main__':
        url = sys.argv[1]
        print(GenerateList(url))
```
