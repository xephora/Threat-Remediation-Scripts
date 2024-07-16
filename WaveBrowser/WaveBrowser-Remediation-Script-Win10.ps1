$process = Get-Process wavebrowser -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
$process = Get-Process SWUpdater -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $paths = @(
            "C:\users\$i\Wavesor Software",
            "C:\users\$i\WebNavigatorBrowser",
            "C:\users\$i\appdata\local\WaveBrowser",
            "C:\users\$i\appdata\local\WebNavigatorBrowser",
            "C:\users\$i\downloads\Wave Browser*.exe",
            "C:\users\$i\appdata\roaming\microsoft\windows\start menu\programs\WaveBrowser.lnk",
            "C:\USERS\$i\APPDATA\ROAMING\MICROSOFT\INTERNET EXPLORER\QUICK LAUNCH\WAVEBROWSER.LNK",
            "C:\USERS\$i\DESKTOP\WAVEBROWSER.LNK"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "WaveBrowser Removal Unsuccessful => $path"
                }
            }
        }
    }
}

$tasks = Get-ScheduledTask -TaskName *Wave* | Select-Object -ExpandProperty TaskName
foreach ($i in $tasks) {
    Unregister-ScheduledTask -TaskName $i -Confirm:$false -ErrorAction SilentlyContinue
}

$taskPaths = @(
    'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Wave*',
    'C:\windows\system32\tasks\Wavesor*'
)
foreach ($taskPath in $taskPaths) {
    if (Test-Path -Path $taskPath) {
        Remove-Item $taskPath -Recurse -ErrorAction SilentlyContinue
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $keys = @(
            "WaveBrowser",
            "Wavesor",
            "WebNavigatorBrowser",
            "Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser",
            "Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser"
        )
        foreach ($key in $keys) {
            $keypath = "Registry::$i\Software\$key"
            if (Test-Path -Path $keypath) {
                Remove-Item $keypath -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $keypath) {
                    Write-Host "WaveBrowser Removal Unsuccessful => $keypath"
                }
            }
        }
        $runKey = "Wavesor SWUpdater"
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
            Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Write-Host "WaveBrowser Removal Unsuccessful => $keypath.$runKey"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($i in $sid_list) {
    if ($i -like "*_Classes*") {
        $classKeys = @(
            "WaveBrwsHTM*",
            "WavesorSWUpdater.CredentialDialogUser",
            "WavesorSWUpdater.CredentialDialogUser.1.0",
            "WavesorSWUpdater.OnDemandCOMClassUser",
            "WavesorSWUpdater.OnDemandCOMClassUser.1.0",
            "WavesorSWUpdater.PolicyStatusUser",
            "WavesorSWUpdater.PolicyStatusUser.1.0",
            "WavesorSWUpdater.Update3COMClassUser",
            "WavesorSWUpdater.Update3COMClassUser.1.0",
            "WavesorSWUpdater.Update3WebUser",
            "WavesorSWUpdater.Update3WebUser.1.0"
        )
        foreach ($classKey in $classKeys) {
            $classPath = "Registry::$i\$classKey"
            if (Test-Path -Path $classPath) {
                Remove-Item $classPath -Recurse -ErrorAction SilentlyContinue
            }
        }
    }
}
