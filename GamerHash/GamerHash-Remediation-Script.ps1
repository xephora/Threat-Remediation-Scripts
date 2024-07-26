$process = Get-Process GamerHash -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {

    $installers = @(Get-ChildItem C:\users\$user -Recurse -Filter "GamerHash*.exe" | ForEach-Object { $_.FullName })
    foreach ($install in $installers) {
        if (Test-Path -Path $install) {
            Remove-Item $install -ErrorAction SilentlyContinue
            if (Test-Path -Path $install) {
                Write-Host "Failed to remove GamerHash: $install"
            }
        }
    }

    $path = "C:\Users\$user\appdata\local\GamerHash"
    if (Test-Path -Path $path) {
        Remove-Item $path -ErrorAction SilentlyContinue -Recurse -Force
        if (Test-Path -Path $path) {
            Write-Host "Failed to remove GamerHash -> $path"
        }
    }

    $shortcut = "C:\users\$user\appdata\roaming\microsoft\windows\start menu\programs\GamerHash.lnk"
    if (Test-Path -Path $shortcut) {
        Remove-Item $shortcut -ErrorAction SilentlyContinue
        if (Test-Path -Path $shortcut) {
            Write-Host "Failed to remove GamerHash -> $shortcut"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $uninstallKey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\GamerHash"
        if (Test-Path $uninstallKey) {
            Remove-Item $uninstallKey -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $uninstallKey) {
                Write-Host "Failed to remove GamerHash -> $uninstallKey"
            }
        }
    }
}

$RegKeys = @(
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Tracing\GamerHash_RASAPI32",
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Tracing\GamerHash_RASMANCS"
)
foreach ($RegKey in $RegKeys) {
    if (Test-Path -Path $RegKey) {
        Remove-Item -Path $RegKey -Recurse -ErrorAction SilentlyContinue
    }
}
