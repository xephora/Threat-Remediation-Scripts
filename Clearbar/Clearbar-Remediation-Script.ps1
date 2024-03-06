Get-Process ClearBar -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process ClearBrowser -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    $installers = @(gci C:\users\$i -r -fi "Clear-*.exe" | % {$_.FullName})
    foreach ($install in $installers) {
        if (test-path -Path $install) {
            rm "$install" -ErrorAction SilentlyContinue
            if (test-path -Path $install) {
                "Failed to remove Clearbar -> $install"
            }
        }
    }
    $installers = @(gci C:\users\$i -r -fi "EasyPrint.*.exe" | % {$_.FullName})
    foreach ($install in $installers) {
        if (test-path -Path $install) {
            rm "$install" -ErrorAction SilentlyContinue
            $installers = @(gci C:\users\$i -r -fi "EasyPrint.*.exe" | % {$_.FullName})
            if (test-path -Path $install) {
                "Failed to remove Clearbar -> $install"
            }
        }
    }
    if (test-path -Path "C:\Users\$i\appdata\local\ClearBar") {
        rm "C:\Users\$i\appdata\local\ClearBar" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\local\ClearBar") {
            "Failed to remove Clearbar -> C:\Users\$i\appdata\local\ClearBar"
        }
    }
    if (test-path -Path "C:\Users\$i\appdata\local\ClearBrowser") {
        rm "C:\Users\$i\appdata\local\ClearBrowser" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\local\ClearBrowser") {
            "Failed to remove Clearbar -> C:\Users\$i\appdata\local\ClearBrowser"
        }
    }
    if (test-path -Path "C:\Users\$i\appdata\local\programs\ClearBar") {
        rm "C:\Users\$i\appdata\local\programs\ClearBar" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\local\programs\ClearBar") {
            "Failed to remove Clearbar -> C:\Users\$i\appdata\local\programs\ClearBar"
        }
    }
}

Remove-Item -Path "C:\windows\system32\tasks\ClearbarStartAtLoginTask" -ErrorAction SilentlyContinue
Remove-Item -Path "C:\windows\system32\tasks\ClearbarUpdateChecker" -ErrorAction SilentlyContinue
Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask' -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker' -Recurse -ErrorAction SilentlyContinue

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        if (test-path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1") {
            Remove-Item "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1" -Recurse -ErrorAction SilentlyContinue
            if (test-path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1") {
                "Failed to remove OneLaunch -> Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1"
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
    }
}
