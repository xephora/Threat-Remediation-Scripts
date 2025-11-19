$process = Get-Process "PDFast" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    $shortcuts = @(
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\pdfast.lnk"
    )
    foreach ($shortcut in $shortcuts) {
        if (Test-Path $shortcut) {
            Remove-Item $shortcut -ErrorAction SilentlyContinue
            if (Test-Path $shortcut) {
                "Failed to remove PDFast shortcut => $shortcut"
            }
        }
    }

    $localPaths = @(
        "C:\Users\$user\AppData\Roaming\pdfast"
    )
    foreach ($localPath in $localPaths) {
        if (Test-Path $localPath) {
            Remove-Item $localPath -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $localPath) {
                "Failed to remove PDFast folder => $localPath"
            }
        }
    }
}

$tasks = Get-ScheduledTask -TaskName *PDFast* -ErrorAction SilentlyContinue | Select-Object -ExpandProperty TaskName
foreach ($task in $tasks) {
    Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
}

$taskPaths = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PDFast",
    "C:\Windows\System32\Tasks\PDFast"
)
foreach ($taskPath in $taskPaths) {
    if (Test-Path $taskPath) {
        Remove-Item $taskPath -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $taskPath) {
            "Failed to remove PDFast scheduled task => $taskPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regPaths = @(
            "Registry::$sid\Software\PDFast"
        )
        foreach ($path in $regPaths) {
            if (Test-Path $path) {
                Remove-Item $path -Recurse -ErrorAction SilentlyContinue
                if (Test-Path $path) {
                    "Failed to remove PDFast registry key => $path"
                }
            }
        }
    }
}
