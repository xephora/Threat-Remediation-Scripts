# Sogou Adware Remediation script

### Actions
- Terminates processes associated with Sogou Adware
- Remove Sogou Adware from the file system.
- Remove Sogou Adware registry keys.
- Removes Sogou Adware uninstall key.
- Performs checks to ensure removal was completed and lets you know if it wasn't successful.

### Description

I have created a script to remove Sogou Adware

### Workarounds if the remediation fails

If the directory `C:\Users\{username}\AppData\Local\sogoupdf` fails to be removed, it is likely that the file `C:\Users\{username}\AppData\Local\sogoupdf\pdfsdkmenu64.dll` is still loaded into the memory of the explorer.exe process (which is the desktop). This could prevent the directory from being fully remediated. As a workaround, you can use `UnloadDll.ps1` script to unhook the module and then attempt to remove it again.
