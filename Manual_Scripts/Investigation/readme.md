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

### Recent Major Updates to WinInspect_v4 (03-25-2023)
- Shortcut enumeration now displays relative paths for enhanced navigation and comprehension.
- Optimization of Documents, Desktop, and Downloads enumeration: empty folders are no longer displayed.
- Scheduled task enumeration now extracts TaskName, Author (Username), UserId (SID), Commandline, and Arguments from deserialized XML objects.
- Efficiency improvements in profile-based process enumeration.
- Enhanced optimization of Browser processes
- Significant optimization of service enumeration, with full binary paths provided
- Disk enumeration now includes both logical disks and image disks (mounted ISOs), offering complete paths when available.

### Update to WinInspect_v4 (05-31-2023)
- For computers that do not have chrome installed, the WinInspect was breaking when enumerating history files.  I added a check if the chrome directory exists.  Small QoL imporvement.
- WinInspect_v3 will be decommissioned.

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

# ScreenConnect-C2Extractor

Quick tool to locate and extract C2 from a ScreenConnect `user.config` configuration file.  Ensure to change the value of `$username` to the target username.
