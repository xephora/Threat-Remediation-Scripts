$process = Get-Process IBuddyService -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
$process = Get-Process IBuddyService -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
$process = Get-Process IBuddyService -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 2
$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $path = "Registry::$sid\Software\IBuddy"
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove IBuddy => $path"
            }
        }
    }
}

$hklmPath = "Registry::HKEY_LOCAL_MACHINE\Software\IBuddy"
if (Test-Path $hklmPath) {
    Remove-Item -Path $hklmPath -Recurse -ErrorAction SilentlyContinue
    if (Test-Path $hklmPath) {
        "Failed to remove IBuddy => $hklmPath"
    }
}

$directories = @(
    "C:\ProgramData\IdleBuddy",
    "C:\Program Files (x86)\IBuddy"
)
foreach ($dir in $directories) {
    if (Test-Path $dir) {
        Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $dir) {
            "Failed to remove IBuddy => $dir"
        }
    }
}
