$process = Get-Process "pageglass" -ErrorAction SilentlyContinue

if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name

foreach ($user in $user_list) {

    if ($user -notlike "*Public*" -and $user -notlike "*Default*") {

        $installers = Get-ChildItem "C:\Users\$user\Downloads" -Filter "PageGlass*.exe" -ErrorAction SilentlyContinue

        foreach ($installer in $installers) {

            if (Test-Path $installer.FullName) {
                Remove-Item $installer.FullName -Force -ErrorAction SilentlyContinue

                if (Test-Path $installer.FullName) {
                    "Failed to remove PageGlass installer -> $($installer.FullName)"
                }
            }
        }

        $paths = @(
            "C:\Users\$user\AppData\Local\PageGlass"
        )

        foreach ($path in $paths) {

            if (Test-Path $path) {
                Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue

                if (Test-Path $path) {
                    "Failed to remove PageGlass artifact -> $path"
                }
            }
        }
    }
}

$tasks = @(
    "PageglassUpdateCheck"
)

foreach ($task in $tasks) {

    $scheduledTask = Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue

    if ($scheduledTask) {
        Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
    }

    $taskPath = "C:\Windows\System32\Tasks\$task"

    if (Test-Path $taskPath) {
        Remove-Item $taskPath -Force -ErrorAction SilentlyContinue

        if (Test-Path $taskPath) {
            "Failed to remove PageGlass scheduled task -> $taskPath"
        }
    }
}

$taskCacheBase = "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE"

foreach ($task in $tasks) {

    $taskCachePath = "$taskCacheBase\$task"

    if (Test-Path $taskCachePath) {
        Remove-Item $taskCachePath -Recurse -Force -ErrorAction SilentlyContinue

        if (Test-Path $taskCachePath) {
            "Failed to remove PageGlass TaskCache registry key -> $taskCachePath"
        }
    }
}
