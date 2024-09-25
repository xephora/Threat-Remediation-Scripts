# Remediation Script for WaveBrowser aka WebNavigator

## Steps to remediate

- Temporarily Stops Browser sessions during remediation. (Optional)
- Removes WaveBrowser from the Filesystem.
- Removes WaveBrowser Services
- Removes WaveBrowser Scheduled tasks.
- Removes WaveBrowser Registry Keys
- Removes WaveBrowser Uninstall Key

### Tested on Windows 10/11

### Why multiple scripts?

- The scripts are decided by operating systems and have a BrowserKill feature if needed.  It is not always required as CrowdStrike blocks the activity.

*Update 04-05-2022: *

- There are scripts for both Windows 10 and Windows 7.  If the check shows that WaveBrowser is still in-use and cannot be removed, the browser will need to be killed in which you can utilized the BrowserKill script.  This was done to avoid end-user impact.

*Update 06-02-2022 *

- A big thank you to GitHub user @jendahl12 for the report.  A removal and check was added for the WaveBrowser uninstall registry key.  This was done so that System Center Configuration Manager can verify and confirm the remediation.

*Update 08-02-2022 *

- Optimizations were made to all WaveBrowser scripts.  I Nested the checks and remediation instead of separating them.  Organized the code a bit better 👌.

*Update 11-29-2022 *

- Additional registry key paths have been added to the remediation script.

```
HKU\{SID}\WavesorSWUpdater.CredentialDialogUser
HKU\{SID}\WavesorSWUpdater.CredentialDialogUser.1.0
HKU\{SID}\WavesorSWUpdater.OnDemandCOMClassUser
HKU\{SID}\WavesorSWUpdater.OnDemandCOMClassUser.1.0
HKU\{SID}\WavesorSWUpdater.PolicyStatusUser
HKU\{SID}\WavesorSWUpdater.PolicyStatusUser.1.0
HKU\{SID}\WavesorSWUpdater.Update3COMClassUser
HKU\{SID}\WavesorSWUpdater.Update3COMClassUser.1.0
HKU\{SID}\WavesorSWUpdater.Update3WebUser
HKU\{SID}\WavesorSWUpdater.Update3WebUser.1.0
```

- Additional shortcut paths have been added to the remediation script.

```
C:\USERS\{PROFILE}\APPDATA\ROAMING\MICROSOFT\INTERNET EXPLORER\QUICK LAUNCH\WAVEBROWSER.LNK
C:\USERS\{PROFILE}\APPDATA\ROAMING\MICROSOFT\WINDOWS\START MENU\PROGRAMS\WAVEBROWSER.LNK
C:\USERS\{PROFILE}\DESKTOP\WAVEBROWSER.LNK
```

*Update 07-16-2024 *
- Script has been templated

*Update 09-24-2024 *
- Additional paths have been added to the remediation script.  Thanks you @chan-man for reporting the issue. https://github.com/xephora/Threat-Remediation-Scripts/issues/10
  
```
C:\Users\{USERNAME}\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\WaveBrowser.lnk
"HKEY_USERS\{SID}\Software\RegisteredApplications" "WaveBrowser.5QMLTPZDDJG2BQZHV26QUN4ZK4"
"HKEY_USERS\{SID}\Software\Classes\CLSID\{9CD78CBC-FD21-4FFF-B452-9D792A58B7C4}\LocalServer32"
"HKEY_USERS\{SID}_Classes\CLSID\{9CD78CBC-FD21-4FFF-B452-9D792A58B7C4}\LocalServer32"
"HKEY_USERS\{SID}\Software\Microsoft\Windows\CurrentVersion\App Paths\wavebrowser.exe"
"HKEY_USERS\{SID}\Software\Clients\StartMenuInternet\WaveBrowser.5QMLTPZDDJG2BQZHV26QUN4ZK4"
```

- Windows 7 WaveBrowser remediation scripts have officially been decommissioned.  Please upgrade your system to Win10/11.
  
```
WaveBrowser-Remediation-Script-Win7-BrowserKill.ps1
WaveBrowser-Remediation-Script-Win7.ps1
```
