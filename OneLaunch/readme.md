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
- Key `OneLaunchChromium` will be removed from the registry hive.
