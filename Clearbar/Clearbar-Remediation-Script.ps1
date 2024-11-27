Get-Process Clear -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process ClearBar -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process ClearBrowser -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    $installers = @(gci C:\users\$user -r -fi "Clear-*.exe" | % {$_.FullName})
    foreach ($install in $installers) {
        if (test-path -Path $install) {
            rm "$install" -ErrorAction SilentlyContinue
            if (test-path -Path $install) {
                "Failed to remove Clearbar -> $install"
            }
        }
    }

    $installers = @(gci C:\users\$user -r -fi "EasyPrint.*.exe" | % {$_.FullName})
    foreach ($install in $installers) {
        if (test-path -Path $install) {
            rm "$install" -ErrorAction SilentlyContinue
            $installers = @(gci C:\users\$i -r -fi "EasyPrint.*.exe" | % {$_.FullName})
            if (test-path -Path $install) {
                "Failed to remove Clearbar -> $install"
            }
        }
    }

    if (test-path "C:\Users\$user\AppData\Local\Programs\Clear") {
        rm "C:\Users\$user\AppData\Local\Programs\Clear" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path "C:\Users\$user\AppData\Local\Programs\Clear") {
            "Failed to remove Clearbar -> C:\Users\$user\AppData\Local\Programs\Clear"
        }
    }

    if (test-path "C:\Users\$user\appdata\local\Clear") {
        rm "C:\Users\$user\appdata\local\Clear" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path "C:\Users\$user\appdata\local\Clear") {
            "Failed to remove Clearbar -> C:\Users\$user\appdata\local\Clear"
        }
    }

    if (test-path -Path "C:\Users\$user\appdata\local\ClearBar") {
        rm "C:\Users\$user\appdata\local\ClearBar" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$user\appdata\local\ClearBar") {
            "Failed to remove Clearbar -> C:\Users\$user\appdata\local\ClearBar"
        }
    }

    if (test-path -Path "C:\Users\$user\appdata\local\ClearBrowser") {
        rm "C:\Users\$user\appdata\local\ClearBrowser" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$user\appdata\local\ClearBrowser") {
            "Failed to remove Clearbar -> C:\Users\$user\appdata\local\ClearBrowser"
        }
    }

    if (test-path -Path "C:\Users\$user\appdata\local\programs\ClearBar") {
        rm "C:\Users\$user\appdata\local\programs\ClearBar" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$user\appdata\local\programs\ClearBar") {
            "Failed to remove Clearbar -> C:\Users\$user\appdata\local\programs\ClearBar"
        }
    }
}

if (test-path "C:\windows\system32\tasks\ClearbarStartAtLoginTask") {
    Remove-Item -Path "C:\windows\system32\tasks\ClearbarStartAtLoginTask" -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\ClearbarStartAtLoginTask") {
        "Failed to remove Clearbar -> C:\windows\system32\tasks\ClearbarStartAtLoginTask"
    }
}

if (test-path "C:\windows\system32\tasks\ClearbarUpdateChecker") {
    Remove-Item -Path "C:\windows\system32\tasks\ClearbarUpdateChecker" -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\ClearbarUpdateChecker") {
        "Failed to remove Clearbar -> C:\windows\system32\tasks\ClearbarUpdateChecker"
    }
}

if (test-path "C:\windows\system32\tasks\ClearStartAtLoginTask") {
    Remove-Item -Path "C:\windows\system32\tasks\ClearStartAtLoginTask" -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\ClearStartAtLoginTask") {
        "Failed to remove Clearbar -> C:\windows\system32\tasks\ClearStartAtLoginTask"
    }
}

if (test-path "C:\windows\system32\tasks\ClearUpdateChecker") {
    Remove-Item -Path "C:\windows\system32\tasks\ClearUpdateChecker" -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\ClearUpdateChecker") {
        "Failed to remove Clearbar -> C:\windows\system32\tasks\ClearUpdateChecker"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask') {
        "Failed to remove Clearbar -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker') {
        "Failed to remove Clearbar -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask') {
        "Failed to remove Clearbar -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker') {
        "Failed to remove Clearbar -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker"
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        if (test-path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1") {
            Remove-Item "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1" -Recurse -ErrorAction SilentlyContinue
            if (test-path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1") {
                "Failed to remove Clearbar -> Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1"
            }
        }

        $keyexists = test-path -path "Registry::$sid\Software\ClearBar"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\ClearBar" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$sid\Software\ClearBar"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$sid\Software\ClearBar"
            }
        }

        $keyexists = test-path -path "Registry::$sid\Software\ClearBar.App"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\ClearBar.App" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$sid\Software\ClearBar.App"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$sid\Software\ClearBar.App"
            }
        }

        $keyexists = test-path -path "Registry::$sid\Software\ClearBrowser"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\ClearBrowser" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$sid\Software\ClearBrowser"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$sid\Software\ClearBrowser"
            }
        }
        
        $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "ClearBar"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "ClearBar" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "ClearBar"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.ClearBar"
            }
        }

        $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "Clear"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Clear" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "Clear"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.Clear"
            }
        }
    }
}
