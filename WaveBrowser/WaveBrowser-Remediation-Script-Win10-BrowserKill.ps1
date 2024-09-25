$process = Get-Process chrome -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
$process = Get-Process firefox -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
$process = Get-Process iexplore -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
$process = Get-Process msedge -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

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
foreach ($username in $user_list) {
    if ($username -notlike "*Public*") {
        $paths = @(
            "C:\users\$username\Wavesor Software",
            "C:\users\$username\WebNavigatorBrowser",
            "C:\users\$username\appdata\local\WaveBrowser",
            "C:\users\$username\appdata\local\WebNavigatorBrowser",
            "C:\users\$username\downloads\Wave Browser*.exe",
            "C:\users\$username\appdata\roaming\microsoft\windows\start menu\programs\WaveBrowser.lnk",
            "C:\USERS\$username\APPDATA\ROAMING\MICROSOFT\INTERNET EXPLORER\QUICK LAUNCH\WAVEBROWSER.LNK",
            "C:\USERS\$username\DESKTOP\WAVEBROWSER.LNK",
            "C:\Users\$username\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\WaveBrowser.lnk"
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
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $keys = @(
            "WaveBrowser",
            "Wavesor",
            "WebNavigatorBrowser",
            "Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser",
            "Microsoft\Windows\CurrentVersion\App Paths\wavebrowser.exe",
            "Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser",
            "Classes\CLSID\{9CD78CBC-FD21-4FFF-B452-9D792A58B7C4}\LocalServer32",
            "Clients\StartMenuInternet\WaveBrowser.5QMLTPZDDJG2BQZHV26QUN4ZK4"
        )
        foreach ($key in $keys) {
            $keypath = "Registry::$sid\Software\$key"
            if (Test-Path -Path $keypath) {
                Remove-Item $keypath -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $keypath) {
                    Write-Host "WaveBrowser Removal Unsuccessful => $keypath"
                }
            }
        }
        $runKey = "Wavesor SWUpdater"
        $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
            Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Write-Host "WaveBrowser Removal Unsuccessful => $keypath.$runKey"
            }
        }
        $runKey = "WaveBrowser.5QMLTPZDDJG2BQZHV26QUN4ZK4"
        $keypath = "Registry::$sid\Software\RegisteredApplications"
        if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
            Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Write-Host "WaveBrowser Removal Unsuccessful => $keypath.$runKey"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -like "*_Classes*") {
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
            "WavesorSWUpdater.Update3WebUser.1.0",
            "CLSID\{9CD78CBC-FD21-4FFF-B452-9D792A58B7C4}\LocalServer32"
        )
        foreach ($classKey in $classKeys) {
            $classPath = "Registry::$sid\$classKey"
            if (Test-Path -Path $classPath) {
                Remove-Item $classPath -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $classPath) {
                    Write-Host "WaveBrowser Removal Unsuccessful => $classPath"
                }
            }
        }
    }
}
