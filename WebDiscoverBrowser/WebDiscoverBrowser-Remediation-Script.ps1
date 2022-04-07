$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

# Terminate Process

Get-Process browser -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

# Remove from file system

rm "C:\Program Files\WebDiscoverBrowser" -Force -Recurse -ErrorAction SilentlyContinue
rm "C:\windows\system32\tasks\WebDiscover Browser Launch Task" -ErrorAction SilentlyContinue
rm "C:\windows\system32\tasks\WebDiscover Browser Update Task" -ErrorAction SilentlyContinue

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\users\$i\AppData\Local\WebDiscoverBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    }
}

# Remove from Registries

Remove-Item -path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WebDiscover Browser Launch Task" -Recurse -ErrorAction SilentlyContinue
Remove-Item -path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WebDiscover Browser Update Task" -Recurse -ErrorAction SilentlyContinue
Remove-ItemProperty -path "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Run" -name WebDiscoverBrowser -ErrorAction SilentlyContinue

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        Remove-Item -Path Registry::$i\Software\WebDiscoverBrowser -Recurse -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name WebDiscoverBrowser -ErrorAction SilentlyContinue
    }
}

# Check Removal

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
	    $result = test-path -Path "C:\users\$i\AppData\Local\WebDiscoverBrowser"
        if ($result -eq "True") {
            "WebDiscover Browser wasn't removed => on C:\users\$i\AppData\Local\WebDiscoverBrowser"
        }
    }
}

$check1 = Test-Path -path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WebDiscover Browser Launch Task" -ErrorAction SilentlyContinue
if ($check1) {
    "This script failed to remove Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WebDiscover Browser Launch Task"
}
else {
    continue
}

$check2 = Test-Path -path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WebDiscover Browser Update Task" -ErrorAction SilentlyContinue
if ($check2) {
    "This script failed to remove Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WebDiscover Browser Update Task"
}
else {
    continue
}

$check2 = Test-Path -path "C:\Program Files\WebDiscoverBrowser" -ErrorAction SilentlyContinue
if ($check2) {
    "This script failed to remove C:\Program Files\WebDiscoverBrowser"
}
else {
    continue
}
