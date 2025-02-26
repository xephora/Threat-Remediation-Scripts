#Epibrowser removal script
#Based on Onelaunch removal script:
#https://github.com/xephora/Threat-Remediation-Scripts/blob/main/OneLaunch/OneLaunch-Remediation-Script.ps1

$process = Get-Process epibrowser -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
$process = Get-Process setup -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Users\$user\AppData\Local\EPISoftware",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\EpiBrowser.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\EpiStart.lnk"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove EpiBrowser -> $path"
                }
            }
        }
    }
}

$tasks = @(
    "EpiBrowserStartup*"
)
foreach ($task in $tasks) {
    $taskPath = "C:\windows\system32\tasks\$task"
    if (Test-Path -Path $taskPath) {
        Remove-Item -Path $taskPath -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path -Path $taskPath) {
            Write-Host "Failed to remove EpiBrowser task -> $taskPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $registryPaths = @(
            "Registry::$sid\Software\EPISoftware",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\EPISoftware EpiBrowser"
        )
        foreach ($regPath in $registryPaths) {
            if (Test-Path -Path $regPath) {
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    Write-Host "Failed to remove EpiBrowser -> $regPath"
                }
            }
        }

        $runKeys = @("EpiBrowserStartup", "EpiBrowserUpdate")
        foreach ($runKey in $runKeys) {
            $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                    Write-Host "Failed to remove EpiBrowser -> $keypath.$runKey"
                }
            }
        }

        $classKeys = @(
            "Registry::$sid\Software\Classes\EPIHTML*",
            "Registry::$sid\Software\Classes\EPIPDF*",
            "Registry::$sid\Software\Clients\StartMenuInternet\EpiBrowser*",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\App Paths\epibrowser.exe"
        )
        foreach ($classKey in $classKeys) {
            if (Test-Path -Path $classKey) {
                Remove-Item $classKey -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $classKey) {
                    Write-Host "Failed to remove EpiBrowser -> $classKey"
                }
            }
        }
    }
}

$taskCacheKeys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\EpiBrowserStartup*"
)
foreach ($taskCacheKey in $taskCacheKeys) {
    if (Test-Path -Path $taskCacheKey) {
        Remove-Item -Path $taskCacheKey -Recurse -ErrorAction SilentlyContinue
    }
}

$registryLMKeys = @(
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MediaPlayer\ShimInclusionList\epibrowser.exe"
)
foreach ($lmKey in $registryLMKeys) {
    if (Test-Path -Path $lmKey) {
        Remove-Item $lmKey -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $lmKey) {
            Write-Host "Failed to remove EpiBrowser -> $lmKey"
        }
    }
}

$schtasknames = @("EpiBrowserStartup*")
$c = 0

foreach ($taskname in $schtasknames) {
    $tasks = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
    foreach ($task in $tasks) {
        $c++
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "Scheduled task '$task.TaskName' has been removed."
    }
}

if ($c -eq 0) {
    Write-Host "No EpiBrowser scheduled tasks were found."
}
