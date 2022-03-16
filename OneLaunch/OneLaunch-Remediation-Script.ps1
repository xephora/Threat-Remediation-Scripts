$users = Get-ChildItem C:\users | Select-Object name -ExpandProperty name
$sids = get-item -path "Registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
$test = @()

get-process -name chromium -ErrorAction SilentlyContinue | Stop-process -Force
get-process -name onelaunch -ErrorAction SilentlyContinue | Stop-Process -Force
get-process -name onelaunchtray -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

foreach ($user in $users) {
    if ($user -ne "Public") {
        $result = Test-Path -path "C:\Users\$user\AppData\Local\OneLaunch"
        if ($result -eq "True") {
            $test += $user
        } else {
            continue
        }
        rm "C:\Users\$user\AppData\Local\OneLaunch" -Force -Recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneLaunch" -Force -Recurse -ErrorAction SilentlyContinue
    }
}

foreach ($sid in $sids){
    if ($sid -notlike "*_Classes") {
        Remove-ItemProperty -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -name "OneLaunch" -ErrorAction SilentlyContinue
        Remove-ItemProperty -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -name "GoogleChromeAutoLaunch_*" -ErrorAction SilentlyContinue
        Remove-Item -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1" -Recurse -ErrorAction SilentlyContinue
        foreach ($i in $test) {
        	$sid = [string]$sid
            $sid = $sid.replace("HKEY_USERS\", "")
        	Remove-ItemProperty -Path "Registry::hklm\System\CurrentControlSet\Services\bam\State\UserSettings\$sid" -name "\Device\HarddiskVolume*\Users\$i\AppData\Local\OneLaunch\*\chromium\chromium.exe" -ErrorAction SilentlyContinue
        	Remove-ItemProperty -Path "Registry::hklm\System\CurrentControlSet\Services\bam\State\UserSettings\$sid" -name "\Device\HarddiskVolume*\Users\$i\AppData\Local\OneLaunch\*\onelaunch.exe" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path "Registry::hklm\System\CurrentControlSet\Services\bam\State\UserSettings\$sid" -name "\Device\HarddiskVolume*\Users\$i\AppData\Local\Temp\*\onelaunch_*" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path "Registry::hklm\System\CurrentControlSet\Services\bam\State\UserSettings\$sid" -name "\Device\HarddiskVolume*\Users\$i\AppData\Local\OneLaunch\*\onelaunchtray.exe" -ErrorAction SilentlyContinue
        }
    }
}

Remove-Item -path "Registry::hklm\Software\OneLaunch" -recurse -ErrorAction SilentlyContinue
Remove-Item -path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\onelaunch_RASAPI32" -recurse -ErrorAction SilentlyContinue
Remove-Item -path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\onelaunch_RASMANCS" -recurse -ErrorAction SilentlyContinue

#Check Removal

foreach ($user in $users) {
    if ($user -ne "Public") {
        $check1 = Test-Path "C:\Users\$user\AppData\Local\OneLaunch"
        if ($check1 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Local\OneLaunch"
        }
        $check2 = Test-Path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneLaunch"
        if ($check2 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneLaunch"
        }
    }
}

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        $check3 = Test-Path -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1" -ErrorAction SilentlyContinue
        if ($check3 -eq "True") {
            "This script failed to remove Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1"
        }
        else {
            continue
        }
    }
}

$check4 = Test-Path -path "Registry::hklm\Software\OneLaunch" -ErrorAction SilentlyContinue
if ($check4) {
    "This script failed to remove HKEY_LOCAL_MACHINE\Software\OneLaunch"
}
else {
    continue
}

$check5 = Test-Path -path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\onelaunch_RASAPI32" -ErrorAction SilentlyContinue
if ($check5) {
    "This script failed to remove HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Tracing\onelaunch_RASAPI32"
}
else {
    continue
}

$check6 = Test-Path -path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\onelaunch_RASMANCS" -ErrorAction SilentlyContinue
if ($check6) {
    "This script failed to remove HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Tracing\onelaunch_RASMANCS"
}
else {
    continue
}
