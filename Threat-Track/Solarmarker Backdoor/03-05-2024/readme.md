# Dumping powershell script from the dotnet PE resource

### Usage: `script.py payload.exe`
```py
from dotnetfile import DotNetPE
import sys

def dump_pspayload(PE):
        PE.get_resources().pop()
        PE.get_resources().pop()
        powershell_payload = PE.get_resources().pop()['Data']
        with open("payload.ps1","wb") as f:
            f.write(powershell_payload)
        print("[+] Dumping Powershell payload.")

if __name__ == "__main__":
        PE = sys.argv[1]
        dotnet_file = DotNetPE(PE)
        dump_pspayload(dotnet_file)
```

### Decrypting solarmarker backdoor
```
$F=[Convert]::FromBase64String('base64_of_dotnet_payload');
$A=New-Object System.Security.Cryptography.AesCryptoServiceProvider;
$A.Key=@([byte]134,230,203,57,108,213,195,172,129,153,11,36,247,96,228,39,130,163,152,76,24,212,82,96,244,139,110,4,236,52,167,6);
$A.IV=@([byte]163,82,139,184,29,144,187,20,130,158,222,74,170,201,62,239);
$_I=New-Object System.IO.MemoryStream(,$A.CreateDecryptor().TransformFinalBlock($F,0,$F.Length));
$_O=New-Object System.IO.MemoryStream;
$_G=New-Object System.IO.Compression.GzipStream $_I,([IO.Compression.CompressionMode]::Decompress);
$_G.CopyTo($_O);
$_G.Close();
$_I.Close();
[system.io.file]::writeallbytes("payload.dll", $_O.ToArray());
```
