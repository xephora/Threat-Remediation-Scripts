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
- For computers that do not have chrome installed, the WinInspect was breaking when enumerating history files.  I added a check if the chrome directory exists.  Small QoL improvement.
- WinInspect_v3 will be decommissioned.

### Update to WinInspect_v4 (12-29-2023)
- Added the updated Edge history file location to the script. "%profile%\AppData\Local\Microsoft\Edge\User Data\Default\History"
- Enumerates all Edge profiles.

### Update to WinInspect_v4 (3-12-2023)
- Shifted down service enumeration to speed up runtime.
- Added temp file enumeration.

### Major update to WinInspect_v4 (4-2-2025)
- Added Uninstall keys enumeration
- Checks `programs` directory within `Start Menu` in addition to `startup`.
- Checks for apps installed from the Windows app store.
- Checks for user's PowerShell history file.
- Removed the temporary file enumeration to improve runtime efficiency and preserve screen real estate.

### Update to WinInspect (10-30-2025)
- Added Program Files (x86 + x64) to the script.
- Added enumeration of RunMRU registry.

### Update to WinInspect (11-14-2025)
- Added enumeration of users Outlook profile

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

## UnloadDll

Description:  
Scans all processes for a specific module and attempts to unload it using FreeLibrary.

- Designed for CrowdStrike but can also be run locally.
- Be sure to replace the values with the appropriate username and module name you wish to unload.
- Disclaimer: I am not responsible for any issues caused by unloading critical modules.

```
[DllScanner]::ScanAndUnload('jsmith', 'wlidprov.dll')
Done. Results in C:\windows\temp\results.log

PS C:\> cat C:\windows\temp\results.log
[+] Starting scan at 6/13/2025 6:28:00 PM
[>] SearchApp (4924) owned by DESKTOP-TEST\jsmith
[>] svchost (5500) owned by DESKTOP-TEST\jsmith
[>] OneDrive (7400) owned by DESKTOP-TEST\jsmith
  [+] Found matching DLL: C:\Windows\System32\wlidprov.dll
      BaseAddress: 0x7FFD9DED0000
      [*] FreeLibrary queued (TID 7772)
[>] msedgewebview2 (4116) owned by DESKTOP-TEST\jsmith
[>] svchost (5048) owned by DESKTOP-TEST\jsmith
[>] taskhostw (5096) owned by DESKTOP-TEST\jsmith
[>] powershell (3028) owned by DESKTOP-TEST\jsmith
[>] RuntimeBroker (7052) owned by DESKTOP-TEST\jsmith
[>] smartscreen (8968) owned by DESKTOP-TEST\jsmith
[>] msedge (4168) owned by DESKTOP-TEST\jsmith
[>] msedgewebview2 (7836) owned by DESKTOP-TEST\jsmith
[>] SecurityHealthSystray (5652) owned by DESKTOP-TEST\jsmith
[>] RuntimeBroker (5364) owned by DESKTOP-TEST\jsmith
[>] RuntimeBroker (6164) owned by DESKTOP-TEST\jsmith
[>] msedge (10172) owned by DESKTOP-TEST\jsmith
[>] ctfmon (4500) owned by DESKTOP-TEST\jsmith
[>] msedge (4648) owned by DESKTOP-TEST\jsmith
[>] vmtoolsd (6796) owned by DESKTOP-TEST\jsmith
[>] SearchApp (492) owned by DESKTOP-TEST\jsmith
[>] dllhost (7788) owned by DESKTOP-TEST\jsmith
[>] msedgewebview2 (3736) owned by DESKTOP-TEST\jsmith
[>] TextInputHost (7972) owned by DESKTOP-TEST\jsmith
[>] SearchProtocolHost (3696) owned by DESKTOP-TEST\jsmith
[>] msedge (8360) owned by DESKTOP-TEST\jsmith
[>] taskhostw (3432) owned by DESKTOP-TEST\jsmith
[>] ShellExperienceHost (9440) owned by DESKTOP-TEST\jsmith
[>] RuntimeBroker (5988) owned by DESKTOP-TEST\jsmith
[>] msedgewebview2 (4608) owned by DESKTOP-TEST\jsmith
[>] msedgewebview2 (1056) owned by DESKTOP-TEST\jsmith
[>] StartMenuExperienceHost (5780) owned by DESKTOP-TEST\jsmith
[>] WinStore.App (9084) owned by DESKTOP-TEST\jsmith
[>] sihost (4980) owned by DESKTOP-TEST\jsmith
[>] RuntimeBroker (7736) owned by DESKTOP-TEST\jsmith
[>] msedgewebview2 (6928) owned by DESKTOP-TEST\jsmith
[>] SkypeApp (8744) owned by DESKTOP-TEST\jsmith
[>] msedge (2208) owned by DESKTOP-TEST\jsmith
[>] explorer (4348) owned by DESKTOP-TEST\jsmith
  [+] Found matching DLL: C:\Windows\System32\wlidprov.dll
      BaseAddress: 0x7FFD9DED0000
      [*] FreeLibrary queued (TID 6284)
[>] svchost (5012) owned by DESKTOP-TEST\jsmith
[>] Taskmgr (6180) owned by DESKTOP-TEST\jsmith
[>] ApplicationFrameHost (2584) owned by DESKTOP-TEST\jsmith
[>] notepad (8492) owned by DESKTOP-TEST\jsmith
[>] svchost (7900) owned by DESKTOP-TEST\jsmith
[>] RuntimeBroker (1396) owned by DESKTOP-TEST\jsmith
[>] UserOOBEBroker (3688) owned by DESKTOP-TEST\jsmith
[>] WWAHost (2580) owned by DESKTOP-TEST\jsmith
[>] conhost (9724) owned by DESKTOP-TEST\jsmith
[>] RuntimeBroker (8296) owned by DESKTOP-TEST\jsmith
[+] Scan complete at 6/13/2025 6:28:28 PM
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
