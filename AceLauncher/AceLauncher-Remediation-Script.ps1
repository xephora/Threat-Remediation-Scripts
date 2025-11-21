$process = Get-Process AceLauncher -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*" -and $user -notlike "*Default*") {

        $paths = @(
            "C:\Users\$user\Downloads\*acelauncher*.exe",
            "C:\Users\$user\AppData\Local\AceLauncher",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Web AceLauncher.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Web AceLauncher.lnk"
        )

        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue

                if (Test-Path -Path $path) {
                    "Failed to remove AceLauncher -> $path"
                }
            }
        }
    }
}

$regHKLM = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Wow64\x86\AceLauncher.exe",
    "Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\ShellCompatibility\Applications\AceLauncher.tmp"
)

foreach ($reg in $regHKLM) {
    if (Test-Path -Path $reg) {
        Remove-Item $reg -Force -Recurse -ErrorAction SilentlyContinue

        if (Test-Path -Path $reg) {
            "Failed to remove AceLauncher -> $reg"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regHKU = @(
            "Registry::$sid\Software\AceLauncherUpdater",
            "Registry::$sid\SOFTWARE\AceLauncher",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\AceLauncher"
        )

        foreach ($regPath in $regHKU) {
            if (Test-Path -Path $regPath) {
                Remove-Item -Path $regPath -Force -Recurse -ErrorAction SilentlyContinue

                if (Test-Path -Path $regPath) {
                    "Failed to remove AceLauncher -> $regPath"
                }
            }
        }
    }
}
