Get-Process AppMaster -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process AppSync -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if (test-path -Path "C:\Users\$i\appdata\roaming\AppMaster") {
        rm "C:\Users\$i\appdata\roaming\AppMaster" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\roaming\AppMaster") {
            "Failed to remove AppMaster -> C:\Users\$i\appdata\roaming\AppMaster"
        }
    }
    if (test-path -Path "C:\Users\$i\AppData\Roaming\AppSync") {
        rm "C:\Users\$i\AppData\Roaming\AppSync" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\AppData\Roaming\AppSync") {
            "Failed to remove AppMaster -> C:\Users\$i\AppData\Roaming\AppSync"
        }
    }
}

if (test-path "C:\windows\system32\tasks\Update_Normandoh") {
    Remove-Item -Path "C:\windows\system32\tasks\Update_Normandoh" -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\Update_Normandoh") {
        "Failed to remove AppMaster -> C:\windows\system32\tasks\Update_Normandoh"
    }
}

if (test-path "C:\windows\system32\tasks\UpdatePrt") {
    Remove-Item -Path "C:\windows\system32\tasks\UpdatePrt" -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\UpdatePrt") {
        "Failed to remove AppMaster -> C:\windows\system32\tasks\UpdatePrt"
    }
}

if (test-path "C:\windows\system32\tasks\WaterfoxLimited") {
    Remove-Item -Path "C:\windows\system32\tasks\WaterfoxLimited" -Recurse -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\WaterfoxLimited") {
        "Failed to remove AppMaster -> C:\windows\system32\tasks\WaterfoxLimited"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Normandoh') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Normandoh' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Normandoh') {
        "Failed to remove AppMaster -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Normandoh"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\UpdatePrt') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\UpdatePrt' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\UpdatePrt') {
        "Failed to remove AppMaster -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\UpdatePrt"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WaterfoxLimited') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WaterfoxLimited' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WaterfoxLimited') {
        "Failed to remove AppMaster -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WaterfoxLimited"
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $keyexists = test-path -path "Registry::$i\Software\WaterfoxLimited"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\WaterfoxLimited" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\WaterfoxLimited"
            if ($keyexists -eq $True) {
                "Failed to remove AppMaster => Registry::$i\Software\WaterfoxLimited"
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "WaterfoxLimited"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WaterfoxLimited" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "WaterfoxLimited"
            if ($keyexists -eq $True) {
                "Failed to remove AppMaster => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.WaterfoxLimited"
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "AppSync"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AppSync" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "AppSync"
            if ($keyexists -eq $True) {
                "Failed to remove AppMaster => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.AppSync"
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "AppMaster"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AppMaster" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "AppMaster"
            if ($keyexists -eq $True) {
                "Failed to remove AppMaster => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.AppMaster"
            }
        }
        if (test-path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Normandoh") {
            Remove-Item -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Normandoh" -Recurse -ErrorAction SilentlyContinue
            if (test-path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Normandoh") {
                "Failed to remove AppMaster => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Normandoh"
            }
        }
        if (test-path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZipCruncher") {
            Remove-Item -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZipCruncher" -Recurse -ErrorAction SilentlyContinue
            if (test-path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZipCruncher") {
                "Failed to remove AppMaster => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZipCruncher"
            }
        }
        if (test-path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Waterfox 102.4.0 (x64 en-US)") {
            Remove-Item -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Waterfox 102.4.0 (x64 en-US)" -Recurse -ErrorAction SilentlyContinue
            if (test-path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Waterfox 102.4.0 (x64 en-US)") {
                "Failed to remove AppMaster => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\Waterfox 102.4.0 (x64 en-US)"
            }
        }
    }
}
