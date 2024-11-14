## ReimageProtector Remediation:

A remediation script will be created shortly.

### File System:
```
C:\ProgramData\Reimage Protector
C:\users\{profile}\Downloads\ReimageRepair.exe
```

### Registry Entries:
```
HKEY_LOCAL_MACHINE\Software\Reimage
HKEY_USERS\{SID}\Software\Reimage
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{10ECCE17-29B5-4880-A8F5-EAD298611484}
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{801B440B-1EE3-49B0-B05D-2AB076D4E8CB}
HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Classes\TypeLib\{FA6468D2-FAA4-4951-A53B-2A5CF9CC0A36}
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\TypeLib\{FA6468D2-FAA4-4951-A53B-2A5CF9CC0A36}
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Reimage.exe
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Reimage Repair
HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\Reimage.exe
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{7346F4FA-E0D7-4BB0-8042-3931496BE1CE}
HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ReimageUpdater
HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\ReimageRealTimeProtector
HKEY_LOCAL_MACHINE\SYSTEM\Setup\FirstBoot\Services\ReimageRealTimeProtector
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ReimageRealTimeProtector
```

```
"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\bam\UserSettings\{SID}" "\Device\HarddiskVolume3\Program Files\Reimage\Reimage Protector\ReiProtectorM.exe"
"HKEY_USERS\{SID}\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched" "{6D809377-6AF0-444B-8957-A3773F02200E}\Reimage\Reimage Protector\ReiProtectorM.exe"
"HKEY_USERS\{SID}\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "C:\Program Files\Reimage\Reimage Protector\ReiProtectorM.exe.FriendlyAppName"
"HKEY_USERS\{SID}\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "C:\Program Files\Reimage\Reimage Protector\ReiProtectorM.exe.ApplicationCompany"
"HKEY_USERS\{SID}_Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "C:\Program Files\Reimage\Reimage Protector\ReiProtectorM.exe.FriendlyAppName"
"HKEY_USERS\{SID}_Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "C:\Program Files\Reimage\Reimage Protector\ReiProtectorM.exe.ApplicationCompany"
```

### Persistence:
```
Task: C:\windows\system32\tasks\ReimageUpdater
ServiceName: ReimageRealTimeProtector

{
"ServiceName":  "ReimageRealTimeProtector",
"Status":  4,
"CanStop":  true,
"DisplayName":  "Reimage Real Time Protector",
"ServiceBinary":  "\"C:\\Program Files\\Reimage\\Reimage Protector\\ReiGuard.exe\""
}
```
