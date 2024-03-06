Get-Process onelaunch -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process onelaunchtray -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process chromium -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2


$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    $installers = @(gci C:\users\$i -r -fi "OneLaunch*.exe" | % {$_.FullName})
    foreach ($install in $installers) {
        if (test-path -Path $install) {
            rm $install
            $installers = @(gci C:\users\$i -r -fi "OneLaunch*.exe" | % {$_.FullName})
            if (test-path -Path $install) {
                "Failed to remove: $install"
            }
        }
    }
    if (test-path -Path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunch.lnk") {
        rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunch.lnk" -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunch.lnk") {
            "Failed to remove OneLaunch -> C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunch.lnk"
        }
    }
    if (test-path -Path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchChromium.lnk") {
        rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchChromium.lnk" -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchChromium.lnk") {
            "Failed to remove OneLaunch -> C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchChromium.lnk"
        }
    }
    if (test-path -Path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchUpdater.lnk") {
        rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchUpdater.lnk" -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchUpdater.lnk") {
            "Failed to remove OneLaunch -> C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchUpdater.lnk"
        }
    }
    if (test-path -Path "C:\Users\$i\desktop\OneLaunch.lnk") {
        rm "C:\Users\$i\desktop\OneLaunch.lnk" -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\desktop\OneLaunch.lnk") {
            "Failed to remove OneLaunch -> C:\Users\$i\desktop\OneLaunch.lnk"
        }
    }
    if (test-path -Path "C:\Users\$i\appdata\local\OneLaunch") {
        rm "C:\Users\$i\appdata\local\OneLaunch" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\local\OneLaunch") {
            "Failed to remove OneLaunch -> C:\Users\$i\appdata\local\OneLaunch"
        }
    }
}

rm "C:\windows\system32\tasks\OneLaunchLaunchTask" -ErrorAction SilentlyContinue
rm "C:\windows\system32\tasks\ChromiumLaunchTask" -ErrorAction SilentlyContinue
rm "C:\windows\system32\tasks\OneLaunchUpdateTask" -ErrorAction SilentlyContinue

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        # uninstall removal key is under construction
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "OneLaunch"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "OneLaunch" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "OneLaunch"
            if ($keyexists -eq $True) {
                "Failed to remove OneLaunch => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.OneLaunch"
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "OneLaunchChromium"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "OneLaunchChromium" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "OneLaunchChromium"
            if ($keyexists -eq $True) {
                "Failed to remove OneLaunch => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.OneLaunchChromium"
            }
        }
        $startupkeys = (gi "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run").Property
        foreach ($key in $startupkeys) {
            if ($key -like "GoogleChromeAutoLaunch*") {
                Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "$key" -ErrorAction SilentlyContinue
            }
        }
        if (test-path -path "Registry::$i\Software\OneLaunch") {
            Remove-Item -Path "Registry::$i\Software\OneLaunch" -Recurse -ErrorAction SilentlyContinue
            if (test-path -path "Registry::$i\Software\OneLaunch") {
                "Failed to remove OneLaunch -> Registry::$i\Software\OneLaunch"
            }
        }
    }
}

if (test-path -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneLaunchLaunchTask') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneLaunchLaunchTask' -Recurse -ErrorAction SilentlyContinue
}

if (test-path -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromiumLaunchTask') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromiumLaunchTask' -Recurse -ErrorAction SilentlyContinue
}

if (test-path -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneLaunchUpdateTask') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneLaunchUpdateTask' -Recurse -ErrorAction SilentlyContinue
}
