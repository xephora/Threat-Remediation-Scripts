$process = Get-Process CrystalPDF -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*" -and $user -notlike "*Default*") {
        $paths = @(
            "C:\Users\$user\Downloads\*CrystalPDF*.exe",
            "C:\Users\$user\AppData\Local\CrystalPDF",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\CrystalPDF.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\CrystalPDF.lnk"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    "Failed to remove CrystalPDF -> $path"
                }
            }
        }
    }
}

$regHKLM = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Wow64\x86\CrystalPDF.exe",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Crystal_updater"
)
foreach ($reg in $regHKLM) {
    if (Test-Path -Path $reg) {
        Remove-Item -Path $reg -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path -Path $reg) {
            "Failed to remove CrystalPDF -> $reg"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }

foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regHKU = @(
            "Registry::$sid\Software\Crystal_updater",
            "Registry::$sid\SOFTWARE\CrystalPDF",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\CrystalPDF"
        )
        foreach ($regPath in $regHKU) {
            if (Test-Path -Path $regPath) {
                Remove-Item -Path $regPath -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    "Failed to remove CrystalPDF -> $regPath"
                }
            }
        }
    }
}
