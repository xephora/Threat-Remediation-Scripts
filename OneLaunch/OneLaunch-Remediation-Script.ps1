$process = Get-Process onelaunch -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}
$process = Get-Process onelaunchtray -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}
$process = Get-Process chromium -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    $installers = @(Get-ChildItem C:\users\$user -Recurse -Filter "OneLaunch*.exe" | ForEach-Object { $_.FullName })
    foreach ($install in $installers) {
        if (Test-Path -Path $install) {
            Remove-Item $install -ErrorAction SilentlyContinue
            if (Test-Path -Path $install) {
                Write-Host "Failed to remove: $install"
            }
        }
    }
    $shortcuts = @(
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunch.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchChromium.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OneLaunchUpdater.lnk",
        "C:\Users\$user\desktop\OneLaunch.lnk"
    )
    foreach ($shortcut in $shortcuts) {
        if (Test-Path -Path $shortcut) {
            Remove-Item $shortcut -ErrorAction SilentlyContinue
            if (Test-Path -Path $shortcut) {
                Write-Host "Failed to remove OneLaunch -> $shortcut"
            }
        }
    }
    $localPath = "C:\Users\$user\appdata\local\OneLaunch"
    if (Test-Path -Path $localPath) {
        Remove-Item $localPath -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $localPath) {
            Write-Host "Failed to remove OneLaunch -> $localPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $uninstallKey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1"
        if (Test-Path $uninstallKey) {
            Remove-Item $uninstallKey -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $uninstallKey) {
                Write-Host "Failed to remove OneLaunch -> $uninstallKey"
            }
        }
        $runKeys = @(
            "OneLaunch",
            "OneLaunchChromium"
        )
        foreach ($key in $runKeys) {
            $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            if ((Get-ItemProperty -Path $keypath -Name $key -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $keypath -Name $key -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $keypath -Name $key -ErrorAction SilentlyContinue)) {
                    Write-Host "Failed to remove OneLaunch => $keypath.$key"
                }
            }
        }
        $paths = @(
            "Registry::$sid\Software\OneLaunch",
            "Registry::$sid\SOFTWARE\Classes\OneLaunchHTML"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove OneLaunch => $path"
                }
            }
        }
    }
}

$tasks = @(
    "OneLaunchLaunchTask",
    "ChromiumLaunchTask",
    "OneLaunchUpdateTask"
)
foreach ($task in $tasks) {
    $taskPath = "C:\windows\system32\tasks\$task"
    if (Test-Path $taskPath) {
        Remove-Item $taskPath -ErrorAction SilentlyContinue
        if (Test-Path $taskPath) {
            Write-Host "Failed to remove OneLaunch -> $taskPath"
        }
    }
}

$taskCacheKeys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneLaunchLaunchTask",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromiumLaunchTask",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneLaunchUpdateTask"
)
foreach ($taskCacheKey in $taskCacheKeys) {
    if (Test-Path -Path $taskCacheKey) {
        Remove-Item -Path $taskCacheKey -Recurse -ErrorAction SilentlyContinue
    }
}
