$users = Get-ChildItem C:\users | Select-Object name -ExpandProperty name
$sids = get-item -path "Registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($user in $users) {
    if ($user -ne "Public") {
        rm "C:\Users\$user\AppData\Local\TaskbarSystem" -Force -Recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$user\AppData\Local\Programs\Taskbar system" -Force -Recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Taskbar system" -Force -Recurse -ErrorAction SilentlyContinue
    }
}

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        remove-ItemProperty -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -name "Taskbar system" -ErrorAction SilentlyContinue
        remove-item -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{C40E1200-5BEC-410C-B3C5-F7B475729D42}_is1" -recurse -ErrorAction SilentlyContinue
    }
}

#Check Removal
foreach ($user in $users) {
    if ($user -ne "Public") {
        $check1 = Test-Path "C:\Users\$user\AppData\Local\TaskbarSystem"
        if ($check1 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Local\TaskbarSystem"
        }
        $check2 = Test-Path "C:\Users\$user\AppData\Local\Programs\Taskbar system"
        if ($check2 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Local\Programs\Taskbar system"
        }
        $check3 = Test-Path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Taskbar system"
        if ($check3 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Taskbar system"
        }
    }
}

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        $check4 = test-path -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{C40E1200-5BEC-410C-B3C5-F7B475729D42}_is1" -ErrorAction SilentlyContinue
        if ($check4) {"This script failed to remove Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{C40E1200-5BEC-410C-B3C5-F7B475729D42}_is1"
        } else {
            continue
        }
    }
}
