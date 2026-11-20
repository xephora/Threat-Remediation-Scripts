$processes = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -eq "pulsebrowser" -or $_.Path -like "*PulseSoftware*" } | Sort-Object -Property Id -Unique

if ($processes) {
    $processes | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*" -and $user -notlike "*Default*") {
        $downloadsPath = "C:\Users\$user\Downloads"
        if (Test-Path $downloadsPath) {
            $installers = Get-ChildItem $downloadsPath -Recurse -File -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.Name -like "*PulseBrowser*.exe" -or
                    $_.Name -like "*PulseBrowser*.msi" -or
                    $_.Name -like "*PulseSoftware*.exe" -or
                    $_.Name -like "*PulseSoftware*.msi"
                }

            foreach ($installer in $installers) {

                if (Test-Path $installer.FullName) {
                    Remove-Item $installer.FullName -Force -ErrorAction SilentlyContinue

                    if (Test-Path $installer.FullName) {
                        "Failed to remove PulseBrowser installer -> $($installer.FullName)"
                    }
                }
            }
        }

        $paths = @(
            "C:\Users\$user\AppData\Local\PulseSoftware",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Pulse Browser.lnk",
            "C:\Users\$user\Desktop\Pulse Browser.lnk"
        )

        foreach ($path in $paths) {
            if (Test-Path $path) {
                Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue

                if (Test-Path $path) {
                    "Failed to remove PulseBrowser artifact -> $path"
                }
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regHKU = @(
            "Registry::$sid\Software\PulseSoftware",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\PulseSoftware PulseBrowser"
        )

        foreach ($regPath in $regHKU) {

            if (Test-Path $regPath) {
                Remove-Item $regPath -Recurse -Force -ErrorAction SilentlyContinue

                if (Test-Path $regPath) {
                    "Failed to remove PulseBrowser registry key -> $regPath"
                }
            }
        }
    }
}
