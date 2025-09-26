$process = Get-Process "AppMaster" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$process = Get-Process "AppSync" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    $paths = @(
        "C:\Users\$user\AppData\Roaming\AppMaster",
        "C:\Users\$user\AppData\Roaming\AppSync"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove AppMaster -> $path"
            }
        }
    }
}

$tasks = @(
    "Update_Normandoh",
    "UpdatePrt",
    "WaterfoxLimited"
)
foreach ($task in $tasks) {
    $taskPath = "C:\Windows\System32\Tasks\$task"
    if (Test-Path $taskPath) {
        Remove-Item $taskPath -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $taskPath) {
            "Failed to remove AppMaster -> $taskPath"
        }
    }
}

$taskCacheKeys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Normandoh",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\UpdatePrt",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\WaterfoxLimited"
)
foreach ($key in $taskCacheKeys) {
    if (Test-Path $key) {
        Remove-Item $key -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $key) {
            "Failed to remove AppMaster -> $key"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        # Keys to remove
        $keysToRemove = @(
            "Registry::$sid\Software\WaterfoxLimited",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\Normandoh",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZipCruncher",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\Waterfox 102.4.0 (x64 en-US)"
        )
        foreach ($key in $keysToRemove) {
            if (Test-Path $key) {
                Remove-Item $key -Recurse -ErrorAction SilentlyContinue
                if (Test-Path $key) {
                    "Failed to remove AppMaster => $key"
                }
            }
        }

        $runKeys = @("WaterfoxLimited", "AppSync", "AppMaster")
        $runPath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        foreach ($runKey in $runKeys) {
            $exists = (Get-Item $runPath).Property -contains $runKey
            if ($exists) {
                Remove-ItemProperty -Path $runPath -Name $runKey -ErrorAction SilentlyContinue
                $stillExists = (Get-Item $runPath).Property -contains $runKey
                if ($stillExists) {
                    "Failed to remove AppMaster => $runPath.$runKey"
                }
            }
        }
    }
}
