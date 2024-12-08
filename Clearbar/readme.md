# Clearbar Remediation script

### Actions
- Terminates processes associated with Clearbar 
- Remove Clearbar from the file system.
- Remove Clearbar registry keys.
- Performs checks to lets you know if the removal wasn't successful.

### Description

I have created a script to remediate Clearbar adware.

### Updates 03-06-2024

- Removed redundancy when cleaning up installation packages from the users' downloads folder.
- Removal of uninstall key will now target `HKU\SID\software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1`
- Thanks to @syntax53 for reporting the issues https://github.com/xephora/Threat-Remediation-Scripts/issues/4.

### Updates 12-08-2024
- Script has been templated
- Additional entries have been added.
- Thanks to @mclaughcj for reporting the issue https://github.com/xephora/Threat-Remediation-Scripts/issues/12
