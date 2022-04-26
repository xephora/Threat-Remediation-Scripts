$users = Get-ChildItem c:\users | select-object name -expandproperty name
$sids = get-item -path "registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($user in $users) {
    if ($user -ne "Public") {
        rm "C:\Users\$user\appdata\roaming\apprun" -force -recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$user\Desktop\Filecoach.lnk" -ErrorAction SilentlyContinue
    }
}

rm "C:\windows\system32\tasks\Update_Zoremov" -force -recurse -ErrorAction SilentlyContinue

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        remove-ItemProperty -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -name "AppRun" -ErrorAction SilentlyContinue
        remove-item -path "Registry::$sid\Software\AppRun" -recurse -ErrorAction SilentlyContinue
        remove-item -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\Zoremov" -recurse -ErrorAction SilentlyContinue
    }
}

remove-item -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov" -recurse -ErrorAction SilentlyContinue

#Check Removal

foreach ($user in $users) {
    if ($user -ne "Public") {
        $check1 = test-path "C:\Users\$user\appdata\roaming\AppRun"
        if ($check1 -eq "True") {
            "This script failed to remove C:\Users\$user\appdata\roaming\AppRun"
        }
        $check2 = test-path "C:\Users\$user\Desktop\Filecoach.lnk"
        if ($check2 -eq "True") {
            "This script failed to remove C:\Users\$user\Desktop\Filecoach.lnk"
        }
    }
}

$check3 = test-path "C:\windows\system32\tasks\Update_Zoremov"
if ($check3 -eq "True") {
    "This script failed to remove C:\windows\system32\tasks\Update_Zoremov"
}

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        $check4 = test-path -path "Registry::$sid\Software\AppRun" -ErrorAction SilentlyContinue
        if ($check4) {
            "This script failed to remove Registry::$sid\Software\AppRun"
        } else {
            continue
        }
        $check5 = test-path -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\Zoremov"
        if ($check5) {
            "This script failed to remove Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\Zoremov"
        }
    }
}

$check6 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov"
if ($check6) {
    "This script failed to remove Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov"
}
