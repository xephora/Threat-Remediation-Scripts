### Dumping powershell payload from resources

Usage: `script.py payload.exe`
```py
from dotnetfile import DotNetPE
import sys

def dump_pspayload(PE):
        PE.get_resources().pop()
        PE.get_resources().pop()
        powershell_payload = PE.get_resources().pop()['Data']
        with open("payload.ps1","wb") as f:
            f.write(powershell_payload)
        if b";};" in powershell_payload:
            print("[+] Dumping Powershell payload.")

if __name__ == "__main__":
        PE = sys.argv[1]
        dotnet_file = DotNetPE(PE)
        dump_pspayload(dotnet_file)
```
