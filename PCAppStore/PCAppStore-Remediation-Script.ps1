$process = Get-Process PCAppStore -ErrorAction SilentlyContinue
if ($process) { $process | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }
$process = Get-Process NW_store -ErrorAction SilentlyContinue
if ($process) { $process | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }
$process = Get-Process Watchdog -ErrorAction SilentlyContinue
if ($process) { $process | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Users\$user\PCAppStore",
            "C:\Users\$user\AppData\roaming\PCAppStore",
            "C:\Users\$user\Appdata\local\pc_app_store"
        )
        foreach ($path in $paths) {
            if (test-path $path) {
                rm -Path $path -Recurse -ErrorAction SilentlyContinue
                if (test-path $path) {
                    "[!] Failed to remove PCAppstore -> $path"
                }
            }
        }
        $path = "C:\Users\$user\downloads\Zoom-Setup-PCAppStore*.exe"
        if (test-path $path) {
            rm $path -ErrorAction SilentlyContinue
            if (test-path $path) {
                $file = ls $path -ErrorAction SilentlyContinue
                "[!] Failed to remove PCAppStore installer => $file"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $keynames = @(
            "PCAppStore",
            "PcAppStoreUpdater"
        )
        foreach ($key in $keynames) {
            $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            $keyexists = (Get-Item $keypath).Property -contains "$key"
            if ($keyexists -eq $True) {
                Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "$key" -ErrorAction SilentlyContinue
                $keyexists = (Get-Item $keypath).Property -contains "$key"
                if ($keyexists -eq $True) {
                    "Failed to remove OneLaunch => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.$key"
                }
            }
        } 
    }
}

if (test-path "C:\windows\system32\tasks\PCAppStoreAutoUpdater") {
    rm "C:\windows\system32\tasks\PCAppStoreAutoUpdater" -ErrorAction SilentlyContinue
    if (test-path "C:\windows\system32\tasks\PCAppStoreAutoUpdater") {
        "[!] Failed to remove PCAppstore => C:\windows\system32\tasks\PCAppStoreAutoUpdater"
    }
}

if (test-path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater") {
    rm "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater" -Recurse -ErrorAction SilentlyContinue
    if (test-path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater") {
        "[!] Failed to remove PCAppstore => Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater"
    }
}
