$process = Get-Process PCAppStore -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}
$process = Get-Process NW_store -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}
$process = Get-Process Watchdog -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Users\$user\PCAppStore",
            "C:\Users\$user\AppData\roaming\PCAppStore",
            "C:\Users\$user\Appdata\local\pc_app_store"
        )
        foreach ($path in $paths) {
            if (Test-Path $path) {
                Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
                if (Test-Path $path) {
                    Write-Host "[!] Failed to remove PCAppstore -> $path"
                }
            }
        }
        $path = "C:\Users\$user\downloads\Zoom-Setup-PCAppStore*.exe"
        if (Test-Path $path) {
            Remove-Item $path -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                $file = Get-ChildItem $path -ErrorAction SilentlyContinue
                Write-Host "[!] Failed to remove PCAppStore installer => $file"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-Object -ExpandProperty PSChildName
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $keynames = @(
            "PCApp",
            "PCAppStore",
            "PCAppStoreAutoUpdater"
        )
        foreach ($key in $keynames) {
            $keypath = "Registry::HKU\$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            if (Get-ItemProperty -Path $keypath -Name $key -ErrorAction SilentlyContinue) {
                Remove-ItemProperty -Path $keypath -Name $key -ErrorAction SilentlyContinue
                if (Get-ItemProperty -Path $keypath -Name $key -ErrorAction SilentlyContinue) {
                    Write-Host "[!] Failed to remove PCAppStore => Registry::HKU\$sid\Software\Microsoft\Windows\CurrentVersion\Run.$key"
                }
            }
        }
        $path = "Registry::HKU\$sid\Software\PCAppStore"
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                Write-Host "[!] Failed to remove PCAppStore registry key => $path"
            }
        }
    }
}

if (Test-Path "C:\windows\system32\tasks\PCAppStoreAutoUpdater") {
    Remove-Item "C:\windows\system32\tasks\PCAppStoreAutoUpdater" -ErrorAction SilentlyContinue
    if (Test-Path "C:\windows\system32\tasks\PCAppStoreAutoUpdater") {
        Write-Host "[!] Failed to remove PCAppstore => C:\windows\system32\tasks\PCAppStoreAutoUpdater"
    }
}

if (Test-Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater") {
    Remove-Item "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater" -Recurse -ErrorAction SilentlyContinue
    if (Test-Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater") {
        Write-Host "[!] Failed to remove PCAppstore => Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PCAppStoreAutoUpdater"
    }
}
