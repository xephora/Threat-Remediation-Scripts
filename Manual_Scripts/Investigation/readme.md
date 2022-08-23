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

### Things to know

- This script does not thoroughly investigate through the system, the script is a light weight tool to quickly enumerate a host to identify suspicious activity.  You can use these scripts as a starting point to assist you with your investigation.
- The script will continue to be improved over-time and additional features will be added.

# ScanDll Script
*Testing Phase 07-30-2022

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
