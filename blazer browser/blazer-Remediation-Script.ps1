$processes = @(
    "blazer",
    "blazer_*"
)

foreach ($proc in $processes) {
    $process = Get-Process $proc -ErrorAction SilentlyContinue
    if ($process) {
        $process | Stop-Process -Force -ErrorAction SilentlyContinue
    }
}

Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name

foreach ($user in $user_list) {
    if ($user -notlike "*Public*" -and $user -notlike "*Default*") {
        $paths = @(
            "C:\Users\$user\AppData\Local\Blazer",
            "C:\Users\$user\Desktop\Blazer.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Blazer.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Blazer.lnk"
        )

        foreach ($path in $paths) {
            if (Test-Path $path) {
                Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path $path) {
                    "Failed to remove Blazer artifact -> $path"
                }
            }
        }
    }
}

$tasks = @(
    "BlazerBrowserStartupTask",
    "BlazerBrowserUpdateTask"
)

foreach ($task in $tasks) {
    $scheduledTask = Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue
    if ($scheduledTask) {
        Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
    }

    $taskPath = "C:\Windows\System32\Tasks\$task"
    if (Test-Path $taskPath) {
        Remove-Item $taskPath -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $taskPath) {
            "Failed to remove Blazer scheduled task -> $taskPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" |
    Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" |
    ForEach-Object { $_.ToString().Trim() }

foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regHKU = @(
            "Registry::$sid\Software\Blazer",
            "Registry::$sid\Software\Classes\AppUserModelId\Blazer.7SPNXAJ6RTUZWN3PPCU2UIIWXM",
            "Registry::$sid\Software\Classes\BlazerHTM.7SPNXAJ6RTUZWN3PPCU2UIIWXM",
            "Registry::$sid\Software\Classes\BlazerPDF.7SPNXAJ6RTUZWN3PPCU2UIIWXM",
            "Registry::$sid\Software\Clients\StartMenuInternet\Blazer.7SPNXAJ6RTUZWN3PPCU2UIIWXM"
        )

        foreach ($regPath in $regHKU) {
            if (Test-Path $regPath) {
                Remove-Item $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path $regPath) {
                    "Failed to remove Blazer registry key -> $regPath"
                }
            }
        }
    }
}
