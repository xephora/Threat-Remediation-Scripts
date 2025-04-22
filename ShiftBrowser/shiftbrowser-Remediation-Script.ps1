$process = Get-Process shift -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Users\$user\AppData\Local\Shift",
            "C:\Users\$user\Desktop\Shift Browser.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Shift\Shift Browser.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Shift.lnk"
        )

        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove ShiftBrowser -> $path"
                }
            }
        }

        $installers = @()
        $installers = (Get-ChildItem "C:\Users\$user\Downloads\Shift - *.exe") | % { $_.FullName}
        foreach ($installer in $installers) {
            if (Test-Path -Path $installer) {
                Remove-Item -Path $installer -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $installer) {
                    Write-Host "Failed to remove ShiftBrowser -> $path"
                }
            }
        }
    }
}

$tasks = @(
    "ShiftLaunchTask"
)
foreach ($task in $tasks) {
    $taskPath = "C:\windows\system32\tasks\$task"
    if (Test-Path -Path $taskPath) {
        Remove-Item -Path $taskPath -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path -Path $taskPath) {
            Write-Host "Failed to remove ShiftBrowser task -> $taskPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }

foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $registryPaths = @(
            "Registry::$sid\Software\Shift",
            "Registry::$sid\SOFTWARE\Clients\StartMenuInternet\Shift",
            "Registry::$sid\Software\Classes\ShiftHTML",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\{95fcf903-63b1-44bd-ab77-358a5bd30aae}_is1",
            "Registry::$sid\SOFTWARE\Classes\CLSID\{635EFA6F-08D6-4EC9-BD14-8A0FDE975159}"
        )

        foreach ($regPath in $registryPaths) {
            if (Test-Path -Path $regPath) {
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    Write-Host "Failed to remove ShiftBrowser -> $regPath"
                }
            }
        }

        $runKeys = @("ShiftAutoLaunch_E5A4D1242AD7DFAA7BA68197713C983F","GoogleChromeAutoLaunch_E5964F24A764F40CAB0A4B52CD44BC66")
        foreach ($runKey in $runKeys) {
            $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                    Write-Host "Failed to remove ShiftBrowser -> $keypath.$runKey"
                }
            }
        }

        $registeredApplications = @("Shift")
        foreach ($regApp in $registeredApplications) {
            $keypath = "Registry::$sid\SOFTWARE\RegisteredApplications"
            if ((Get-ItemProperty -Path $keypath -Name $regApp -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $keypath -Name $regApp -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $keypath -Name $regApp -ErrorAction SilentlyContinue)) {
                    Write-Host "Failed to remove ShiftBrowser -> $keypath.$regApp"
                }
            }
        }


    }
}

$taskCacheKeys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{E88F1AB4-6648-4E46-8256-20EBDB550948}",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\ShiftLaunchTask"
)
foreach ($taskCacheKey in $taskCacheKeys) {
    if (Test-Path -Path $taskCacheKey) {
        Remove-Item -Path $taskCacheKey -Recurse -ErrorAction SilentlyContinue
    }
}
