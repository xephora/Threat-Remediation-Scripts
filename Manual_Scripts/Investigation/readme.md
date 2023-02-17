# Useful investigation scripts to enumerate the system

# Investigation Script
- Designed for CrowdStrike, but can run locally.
- Please be sure to replace the username placeholder with the target username you want to investigate.  Example below:

```
Windows
$username = "<USERNAME>" => $username = "admin"

MAC
username="<USERNAME>" => username="admin"
```

The Inspect script does not thoroughly investigate through the system.  The script is a light weight tool to quickly enumerate a host to identify suspicious activity.  You can use these as a starting point to assist you with your investigation.

### Recent updates to WinInspect (01-11-2023)
- Added checks for vhd files stored in downloads, documents and desktop
- Added additional inspection paths "C:\program files\common files", "C:\program files (x86)\common files", "C:\users\profile\Appdata\Local\Programs", "C:\users\public", "C:\users\public\desktop".
- Enumerate of virtual disk image.
- Optimized existing code.
- Enumerate Windows Defender logs.  
x Enumerate Chrome Extensions. (Testing Phase) If you experience any issues with this feature, feel free to report as an issue. (Removed 01-20-2023 (Noisy feature)

### Recent Updates to WinInspect (02-16-2023)
- Added enumeration of Chrome Extension back onto the script.  The script will attempt to lookup the extension and name it appropriately.

## ScanDLL

Description:  
Scans all processes for a particular module.

- Designed for CrowdStrike, but can run locally.
- Please be sure to replace the $dllkeyword value to the module name you are looking for.
- To perform a deep scan, the script should be ran as adminstrator.  The script also lets you know if you are not running as administrator as a friendly reminder.

```
Entered an example Dll: $dllkeyword = "FLTLIB.DLL"

Scan Results:

.\ScanDll.ps1
[+] Scanning Dlls..
[+] Discovered Dependency: C:\WINDOWS\SYSTEM32\FLTLIB.DLL on Process: explorer
[+] Discovered Dependency: C:\WINDOWS\SYSTEM32\FLTLIB.DLL on Process: gamingservices
[+] Discovered Dependency: C:\WINDOWS\SYSTEM32\FLTLIB.DLL C:\WINDOWS\SYSTEM32\FLTLIB.DLL on Process: svchost

Running the script without administrator:

.\ScanDll.ps1
[INFO] Running Scanner with limited privileges. This will restrict the scan results. Please run as administrator.
[+] Scanning Dlls..
[+] Discovered Dependency: C:\WINDOWS\SYSTEM32\FLTLIB.DLL on Process: explorer
```

# Win-PortScanner

- A PowerShell Port scanner that is designed to quickly scan a neighboring device.  It only scans the very basic ports, DNS, SMB, HTTP, HTTPS, WinRM, RDP.
- Please be sure to replace the IP Placeholder with the IP address you are port scanning.


```
$ip = "ENTERIPHERE"

Example: $ip = "192.168.1.125"
```
