$users = Get-ChildItem c:\users | select-object name -expandproperty name
$sids = get-item -path "registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

get-process -name HDMTray -ErrorAction SilentlyContinue | stop-process -Force
sleep 2

foreach ($user in $users) {
    if ($user -ne "Public") {
        rm "C:\Users\$user\AppData\Roaming\PC HelpSoft Driver Updater" -force -recurse -ErrorAction SilentlyContinue
    }
}

rm "C:\ProgramData\Desktop\PC HelpSoft Driver Updater.lnk" -ErrorAction SilentlyContinue
rm "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PC HelpSoft Driver Updater" -force -recurse -ErrorAction SilentlyContinue
rm "C:\Program Files (x86)\PC HelpSoft Driver Updater" -force -recurse -ErrorAction SilentlyContinue
rm "C:\Windows\system32\Tasks\PC HelpSoft Driver Updater automatic scan and new device notifications" -ErrorAction SilentlyContinue

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        remove-item -path "Registry::$sid\Software\PC HelpSoft Driver Updater" -recurse -ErrorAction SilentlyContinue
    }
}

remove-Item -Path "Registry::hklm\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PC HelpSoft Driver Updater_is1" -recurse -ErrorAction SilentlyContinue

#Check Removal

foreach ($user in $users) {
    if ($user -ne "Public") {
        $check1 = test-path "C:\Users\$user\AppData\Roaming\PC HelpSoft Driver Updater"
        if ($check1 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Roaming\PC HelpSoft Driver Updater"
        }
    }
}

$check2 = Test-Path "C:\ProgramData\Desktop\PC HelpSoft Driver Updater.lnk"
if ($check2 -eq "True"){
    "This script failed to remove C:\ProgramData\Desktop\PC HelpSoft Driver Updater.lnk"
}
else {
    continue
}

$check3 = Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PC HelpSoft Driver Updater"
if ($check3 -eq "True"){
    "This script failed to remove C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PC HelpSoft Driver Updater"
}
else {
    continue
}

$check4 = Test-Path "C:\Program Files (x86)\PC HelpSoft Driver Updater"
if ($check4 -eq "True"){
    "This script failed to remove C:\Program Files (x86)\PC HelpSoft Driver Updater"
}
else {
    continue
}

$check5 = Test-Path "C:\Windows\system32\Tasks\PC HelpSoft Driver Updater automatic scan and new device notifications"
if ($check5 -eq "True"){
    "This script failed to remove C:\Windows\system32\Tasks\PC HelpSoft Driver Updater automatic scan and new device notifications"
}
else {
    continue
}

foreach ($sid in $sids) {
    if ($sid -notlike "*_Classes") {
        $check6 = test-path -path "Registry::$sid\Software\PC HelpSoft Driver Updater" -ErrorAction SilentlyContinue
        if ($check6) {"This script failed to remove Registry::$sid\Software\PC HelpSoft Driver Updater"} 
            else {
                continue
            }
    }
}

$check7 = "Registry::hklm\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PC HelpSoft Driver Updater_is1"
if ($check7) {
    "This script failed to remove Registry::hklm\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PC HelpSoft Driver Updater_is1"
} 
else {
    continue
}
