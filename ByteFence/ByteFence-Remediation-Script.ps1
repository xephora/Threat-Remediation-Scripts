# Terminate Processes

Get-Process ByteFenceService -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process rtop_bg -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process rtop_svc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Stopping and Removing Services

Stop-Service -Name ByteFenceService -Force -ErrorAction SilentlyContinue
#Remove-Service -Name ByteFenceService -Force -ErrorAction SilentlyContinue
# Remove-Service cmdlet was introduced in PowerShell 6.0 and may not work on certain devices.  If the device has Powershell 6.0 or greater, please uncomment the above line.
# https://github.com/MicrosoftDocs/PowerShell-Docs/issues/4510
sleep 2

# Removal from file system

rm "C:\Program Files\ByteFence" -Force -Recurse -ErrorAction SilentlyContinue
rm "C:\ProgramData\ByteFence" -Force -Recurse -ErrorAction SilentlyContinue
rm "C:\windows\system32\tasks\ByteFence" -ErrorAction SilentlyContinue

# Removal from registries

Remove-Item -path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ByteFence" -Recurse -ErrorAction SilentlyContinue
Remove-Item -path "Registry::HKEY_LOCAL_MACHINE\Software\ByteFence" -Recurse -ErrorAction SilentlyContinue

# Check removal

$check1 = Test-Path -path "C:\Program Files\ByteFence" -ErrorAction SilentlyContinue
if ($check1) {
    "Script failed to remove C:\Program Files\ByteFence"
}
else {
    continue
}

$check2 = Test-Path -path "C:\ProgramData\ByteFence" -ErrorAction SilentlyContinue
if ($check2) {
    "Script failed to remove C:\ProgramData\ByteFence"
}
else {
    continue
}

$check3 = Test-Path -path "C:\windows\system32\tasks\ByteFence" -ErrorAction SilentlyContinue
if ($check3) {
    "Script failed to remove C:\windows\system32\tasks\ByteFence"
}
else {
    continue
}

$check4 = Test-Path -path "Registry::HKEY_LOCAL_MACHINE\Software\ByteFence" -ErrorAction SilentlyContinue
if ($check4) {
    "Script failed to remove Registry::HKEY_LOCAL_MACHINE\Software\ByteFence"
}
else {
    continue
}

$check5 = Test-Path -path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ByteFence" -ErrorAction SilentlyContinue
if ($check5) {
    "Script failed to remove Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ByteFence"
}
else {
    continue
}
