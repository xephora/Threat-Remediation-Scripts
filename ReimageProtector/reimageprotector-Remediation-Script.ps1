$process = Get-Process ReimageApp -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$process = Get-Process ReiGuard -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Program Files\Reimage",
            "C:\ProgramData\Reimage Protector",
            "C:\users\$user\Downloads\ReimageRepair.exe"
        )

        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove ShiftBrowser -> $path"
                }
            }
        }
    }
}

$tasks = @(
    "ReimageUpdater"
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
            "Registry::$sid\Software\Reimage"
        )

        foreach ($regPath in $registryPaths) {
            if (Test-Path -Path $regPath) {
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    Write-Host "Failed to remove ShiftBrowser -> $regPath"
                }
            }
        }

        $runKeys = @("Reimage")
        foreach ($runKey in $runKeys) {
            $keypath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
            if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
                    Write-Host "Failed to remove ShiftBrowser -> $keypath.$runKey"
                }
            }
        }
    }
}

$taskCacheKeys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{7346F4FA-E0D7-4BB0-8042-3931496BE1CE}",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ReimageUpdater"
)
foreach ($taskCacheKey in $taskCacheKeys) {
    if (Test-Path -Path $taskCacheKey) {
        Remove-Item -Path $taskCacheKey -Recurse -ErrorAction SilentlyContinue
    }
}

$runKey = "Reimage"
$keypath = "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
    Remove-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue
    if ((Get-ItemProperty -Path $keypath -Name $runKey -ErrorAction SilentlyContinue)) {
        Write-Host "Failed to remove ShiftBrowser -> $keypath.$runKey"
    }
}

$regKeys = @(
    "Registry::HKLM\SOFTWARE\Classes\CLSID\{10ECCE17-29B5-4880-A8F5-EAD298611484}",
    "Registry::HKLM\SOFTWARE\Classes\CLSID\{801B440B-1EE3-49B0-B05D-2AB076D4E8CB}",
    "Registry::HKLM\SOFTWARE\WOW6432Node\Classes\TypeLib\{FA6468D2-FAA4-4951-A53B-2A5CF9CC0A36}",
    "Registry::HKLM\SOFTWARE\Classes\TypeLib\{FA6468D2-FAA4-4951-A53B-2A5CF9CC0A36}",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Reimage.exe",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Reimage Repair",
    "Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\Reimage.exe",
    "Registry::HKEY_LOCAL_MACHINE\Software\Reimage"
)
foreach ($regKey in $regKeys) {
    if (Test-Path -Path $regKey) {
        Remove-Item -Path $regKey -Recurse -ErrorAction SilentlyContinue
    }
}

$serviceKeys = @(
    "Registry::HKLM\SYSTEM\ControlSet001\Services\ReimageRealTimeProtector",
    "Registry::HKLM\SYSTEM\Setup\FirstBoot\Services\ReimageRealTimeProtector",
    "Registry::HKLM\SYSTEM\CurrentControlSet\Services\ReimageRealTimeProtector"
)
foreach ($serviceKey in $serviceKeys) {
    if (Test-Path -Path $serviceKey) {
        Remove-Item -Path $serviceKey -Recurse -ErrorAction SilentlyContinue
    }
}

$service = Get-Service -Name 'ReimageRealTimeProtector' -ErrorAction SilentlyContinue
if ($service) { $service | Stop-Service -Force -ErrorAction SilentlyContinue }

if ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -eq 0) {
    Remove-Service -Name $service -Force -ErrorAction SilentlyContinue
} else {
    Get-WmiObject -Class Win32_Service -Filter "Name='ReimageRealTimeProtector'" | Remove-WmiObject
}
