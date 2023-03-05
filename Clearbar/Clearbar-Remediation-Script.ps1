Get-Process ClearBar -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process ClearBrowser -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    $installers = @(gci C:\users\$i -r -fi "Clear-*.exe" | % {$_.FullName})
    foreach ($install in $installers) {
        if (test-path -Path $install) {
            rm "$install" -ErrorAction SilentlyContinue
            $installers = @(gci C:\users\$i -r -fi "Clear-*.exe" | % {$_.FullName})
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
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $keyexists = test-path -path "Registry::$i\Software\ClearBar"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\ClearBar" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\ClearBar"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$i\Software\ClearBar"
            }
        }
        $keyexists = test-path -path "Registry::$i\Software\ClearBar.App"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\ClearBar.App" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\ClearBar.App"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$i\Software\ClearBar.App"
            }
        }
        $keyexists = test-path -path "Registry::$i\Software\ClearBrowser"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\ClearBrowser" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\ClearBrowser"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$i\Software\ClearBrowser"
            }
        }
        $regkeys = @(gci "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\*_is1")
        foreach ($key in $regkeys) {
            if (test-path -Path $key) {
                Remove-Item -Path "Registry::$key" -Recurse
                if (test-path -Path $key) {
                    "Failed to remove Clearbar -> $key"
                }
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "ClearBar"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "ClearBar" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "ClearBar"
            if ($keyexists -eq $True) {
                "Failed to remove Clearbar => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.com.squirrel.123movies.123movies"
            }
        }
    }
}
