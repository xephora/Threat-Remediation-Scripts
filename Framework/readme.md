# Framework Adware Remediation script

### Actions
- Terminates processes associated with Framework Adware
- Remove Framework Adware from the file system.
- Remove Framework Adware registry keys.
- Performs checks to ensure removal was completed and lets you know if it wasn't successful.

### Description

I have created a script to remediate Framework adware.

### Additional Information

Adware checks Geo Location, BIOS Information, function `AddClipboardFormatListener` sends notification when the clip-board data changes (the data saved in memory when the user copy-paste).  Also, custom function `GetForegroundWindowSpam` seems to grab handle of the foreground window(s) which may indicate its monitoring users interactions with applications.

Installer: Your File Is Ready To Download.exe  
Hash:`37eb3b07e44ea70dcfb7c7bd274691bd0366c04815f12d267d7f210adf48a1e7`  
Written: Framework.exe (Chromium)  
Hash:`1becc3d19333e9d8d212477bba8b6680906b1758ac52e98159c72895b480805a`  
Dynamic Analysis: https://tria.ge/230509-v1l2zsfa7t/behavioral1  
