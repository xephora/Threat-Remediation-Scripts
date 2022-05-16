$users = Get-ChildItem c:\users | select-object name -expandproperty name
$sids = get-item -path "registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($user in $users) {
    if ($user -ne "Public") {
        rm "C:\Users\$user\AppData\Roaming\Browser Assistant" -force -recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\BrowserAssistant.lnk" -ErrorAction SilentlyContinue
        rm "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.lnk" -ErrorAction SilentlyContinue
    }
}

rm "C:\windows\system32\tasks\BA Scheduler" -ErrorAction SilentlyContinue

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        remove-item -path "Registry::$sid\Software\Realistic Media Inc." -recurse -ErrorAction SilentlyContinue
    }
}

remove-item -path "Registry::Hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BA Scheduler" -recurse -ErrorAction SilentlyContinue

#Check Removal

foreach ($user in $users) {
    if ($user -ne "Public") {
        $check1 = test-path "C:\Users\$user\AppData\Roaming\Browser Assistant"
        if ($check1 -eq "True") {
            "This script failed to remove C:\Users\$user\appdata\roaming\Browser Assistant"
        }
        $check2 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\BrowserAssistant.lnk"
        if ($check2 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\BrowserAssistant.lnk"
        }
        $check3 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.lnk"
        if ($check3 -eq "True"){
            "This script failed to remove C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.lnk"
        }
    }
}

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        $check4 = test-path -path "Registry::$sid\Software\Realistic Media Inc." -ErrorAction SilentlyContinue
        if ($check4) {
            "This script failed to remove Registry::$sid\Software\Realistic Media Inc."
        }
    }
}
