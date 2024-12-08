$process = Get-Process Clear -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
$process = Get-Process ClearBar -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
$process = Get-Process ClearBrowser -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    $installers = @(Get-ChildItem C:\users\$user -Recurse -Filter "Clear-*.exe" | ForEach-Object { $_.FullName })
    foreach ($install in $installers) {
        if (Test-Path -Path $install) {
            Remove-Item $install -ErrorAction SilentlyContinue
            if (Test-Path -Path $install) {
                Write-Host "Failed to remove Clearbar installer -> $install"
            }
        }
    }

    $paths = @(
        "C:\Users\$user\AppData\Local\Programs\Clear",
        "C:\Users\$user\AppData\Local\Clear",
        "C:\Users\$user\AppData\Local\ClearBar",
        "C:\Users\$user\AppData\Local\ClearBrowser",
        "C:\Users\$user\AppData\Local\Programs\ClearBar"
    )
    foreach ($path in $paths) {
        if (Test-Path -Path $path) {
            Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
            if (Test-Path -Path $path) {
                Write-Host "Failed to remove Clearbar -> $path"
            }
        }
    }
}

$tasks = @(
    "C:\windows\system32\tasks\ClearbarStartAtLoginTask",
    "C:\windows\system32\tasks\ClearbarUpdateChecker",
    "C:\windows\system32\tasks\ClearStartAtLoginTask",
    "C:\windows\system32\tasks\ClearUpdateChecker"
)
foreach ($task in $tasks) {
    if (Test-Path -Path $task) {
        Remove-Item $task -ErrorAction SilentlyContinue
        if (Test-Path -Path $task) {
            Write-Host "Failed to remove Clearbar task -> $task"
        }
    }
}

$taskCacheKeys = @(
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask',
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker',
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask',
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker',
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearWeatherCheck'
)
foreach ($taskCacheKey in $taskCacheKeys) {
    if (Test-Path -Path $taskCacheKey) {
        Remove-Item $taskCacheKey -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $taskCacheKey) {
            Write-Host "Failed to remove Clearbar -> $taskCacheKey"
        }
    }
}

$registryKeys = @(
    'Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Tracing\ClearBar_RASAPI32',
    'Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Tracing\ClearBar_RASMANCS'
)
foreach ($key in $registryKeys) {
    if (Test-Path -Path $key) {
        Remove-Item $key -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $key) {
            Write-Host "Failed to remove Clearbar -> $key"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $registryPaths = @(
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1",
            "Registry::$sid\Software\ClearBar",
            "Registry::$sid\Software\ClearBar.App",
            "Registry::$sid\Software\ClearBrowser"
        )
        foreach ($regPath in $registryPaths) {
            if (Test-Path -Path $regPath) {
                Remove-Item $regPath -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    Write-Host "Failed to remove Clearbar -> $regPath"
                }
            }
        }
        $runKeys = @("ClearBar", "Clear")
        foreach ($runKey in $runKeys) {
            $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                    Write-Host "Failed to remove Clearbar -> $keypath.$runKey"
                }
            }
        }
    }
}
