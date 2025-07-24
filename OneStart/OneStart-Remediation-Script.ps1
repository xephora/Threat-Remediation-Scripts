$process = Get-Process OneStart -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
$process = Get-Process UpdaterSetup -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    $installers = @(Get-ChildItem "C:\users\$user\Downloads" -Recurse -Filter "OneStart*.exe" | ForEach-Object { $_.FullName })
    foreach ($install in $installers) {
        if (Test-Path -Path $install) {
            Remove-Item $install -ErrorAction SilentlyContinue
            if (Test-Path -Path $install) {
                Write-Host "Failed to remove OneStart installer -> $install"
            }
        }
    }

    $paths = @(
        "C:\Users\$user\AppData\Local\OneStart.ai",
        "C:\Users\$user\OneStart.ai",
        "C:\Users\$user\Desktop\OneStart.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\OneStart.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneStart.lnk"
    )
    foreach ($path in $paths) {
        if (Test-Path -Path $path) {
            Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
            if (Test-Path -Path $path) {
                Write-Host "Failed to remove OneStart -> $path"
            }
        }
    }
}

$path = "C:\WINDOWS\system32\config\systemprofile\AppData\Local\OneStart.ai"
if (test-path -Path $path) {
    Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $path) {
            Write-Host "Failed to remove OneStart -> $path"
        }
}

$tasks = @(
    "C:\Windows\System32\Tasks\OneStartUser",
    "C:\windows\system32\tasks\OneStartAutoLaunchTask*"
)
foreach ($task in $tasks) {
    if (Test-Path -Path $task) {
        Remove-Item $task -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $task) {
            Write-Host "Failed to remove OneStart task -> $task"
        }
    }
}

$taskCacheKeys = @(
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneStartAutoLaunchTask*',
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\OneStartUser'
)
foreach ($taskCacheKey in $taskCacheKeys) {
    if (Test-Path -Path $taskCacheKey) {
        Remove-Item $taskCacheKey -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $taskCacheKey) {
            Write-Host "Failed to remove OneStart -> $taskCacheKey"
        }
    }
}

$registryKeys = @(
    'Registry::HKLM\Software\WOW6432Node\Microsoft\Tracing\OneStart_RASAPI32',
    'Registry::HKLM\Software\WOW6432Node\Microsoft\Tracing\OneStart_RASMANCS',
    'Registry::HKLM\Software\Microsoft\MediaPlayer\ShimInclusionList\onestart.exe'
)
foreach ($key in $registryKeys) {
    if (Test-Path -Path $key) {
        Remove-Item $key -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $key) {
            Write-Host "Failed to remove OneStart -> $key"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $registryPaths = @(
            "Registry::$sid\Software\Clients\StartMenuInternet\OneStart.IOZDYLUF4W5Y3MM3N77XMXEX6A",
            "Registry::$sid\Software\OneStart.ai",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\OneStart.ai OneStart"
        )
        foreach ($regPath in $registryPaths) {
            if (Test-Path -Path $regPath) {
                Remove-Item $regPath -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    Write-Host "Failed to remove OneStart -> $regPath"
                }
            }
        }
        $runKeys = @("OneStartUpdate", "OneStartBarUpdate","OneStartBar","OneStart", "OneStartChromium")
        foreach ($runKey in $runKeys) {
            $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                    Write-Host "Failed to remove OneStart -> $keypath.$runKey"
                }
            }
        }
    }
}
