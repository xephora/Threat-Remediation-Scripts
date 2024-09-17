# OneLaunch Remediation script

### Actions
- Terminates processes associated with OneLaunch
- Remove OneLaunch from the file system.
- Remove OneLaunch registry keys.
- Removes OneLaunch uninstall key.
- Performs checks to ensure removal was completed and lets you know if it wasn't successful.

### Description

I created a script to remediate OneLaunch.

### Updates 02-28-2023

- An update to OneLaunch seem to have broke the existing script.  I've updated and optimized the script.
- Thank you to @mcrommert for reporting the issue https://github.com/xephora/Threat-Remediation-Scripts/issues/3. 

### Updates 05-25-2023

The following paths, registry keys, tasks, shortcuts were added to the remediation script:

- shortcut `OneLaunchChromium.lnk` will be removed from users startup folder.
- Tasks `ChromiumStartupProxy` and `OneLaunchUpdateTask` will be removed from both Filesystem and Registry Hive
- Startup Key `OneLaunchChromium` will be removed from the registry hive.

### Updates 07-05-2023

The following shortcuts were added to the remediation script.

- shortcut `OneLaunchUpdater.lnk` will be removed from the startup folder
- shortcut `OneLaunch.lnk` will be removed from the user's desktop.

### Updates 03-06-2024

Optimizations have been made to eliminate redundancy, and a bug related to the removal of the uninstall key has been fixed.

- Registry property `HKU\SID\SOFTWARE\RegisteredApplications.OneLaunch` will be removed from the registry hive.
- Registry key `HKU\SID\SOFTWARE\Classes\OneLaunchHTML` will be removed from the registry hive.
- Removed redundancy when cleaning installation packages from the users' downloads folder.
- Removal of uninstall key will now target `HKU\SID\Software\Microsoft\Windows\CurrentVersion\Uninstall\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1`.
- Thank you to @syntax53 for reporting the issue https://github.com/xephora/Threat-Remediation-Scripts/issues/4.

### Update 07-16-2024

Code has been cleaned up and templated.

### Update 07-23-2024

- Added path `C:\users\{user}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneLaunch` to the remediation script.  The new path was added after OneLaunch upgraded to  version 5.25.0.
- Thank you to @zzLukozz and @chan-man for reporting the issue. https://github.com/xephora/Threat-Remediation-Scripts/issues/6 and https://github.com/xephora/Threat-Remediation-Scripts/issues/9

### Update 08-16-2024
- Due to a recent update of OneLaunch (v5.32.1), additional paths were added to the remediation script.
- Thank you to @CartmansPiehole for reporting the issue. https://github.com/xephora/Threat-Remediation-Scripts/issues/8
