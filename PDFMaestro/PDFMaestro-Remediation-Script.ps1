$process = Get-Process PDFMaestro -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}

$process = Get-Process PDFMaestroUpdater -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2 
}

Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {

    $installers = Get-ChildItem "C:\Users\$user\Downloads" -Filter "PDFMaestroSetup_*.exe" -ErrorAction SilentlyContinue
    foreach ($installer in $installers) {
        if (Test-Path $installer.FullName) {
            Remove-Item $installer.FullName -Force -ErrorAction SilentlyContinue
            if (Test-Path $installer.FullName) {
                "Failed to remove PDFMaestro installer -> $($installer.FullName)"
            }
        }
    }

    $paths = @(
        "C:\Users\$user\AppData\Roaming\SB",
        "C:\Users\$user\Desktop\PDF Maestro.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PDF Maestro\PDF Maestro.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PDF Maestro.lnk"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove PDFMaestro artifact -> $path"
            }
        }
    }
}

$systemPath = "C:\WINDOWS\system32\config\systemprofile\AppData\Roaming\SB"
if (Test-Path $systemPath) {
    Remove-Item $systemPath -Recurse -Force -ErrorAction SilentlyContinue
    if (Test-Path $systemPath) {
        "Failed to remove PDFMaestro system artifact -> $systemPath"
    }
}

$tasks = @(
    "PDFMaestroLauncher",
    "PDFMaestroUpdater"
)

foreach ($task in $tasks) {
    $taskPath = "C:\Windows\System32\Tasks\$task"
    if (Test-Path $taskPath) {
        Remove-Item $taskPath -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $taskPath) {
            "Failed to remove PDFMaestro scheduled task -> $taskPath"
        }
    }
}

$taskCache = Get-ChildItem "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE" -ErrorAction SilentlyContinue | Where-Object {
    $_.PSChildName -like "PDFMaestro*"
}

foreach ($key in $taskCache) {
    if (Test-Path $key.PSPath) {
        Remove-Item $key.PSPath -Recurse -ErrorAction SilentlyContinue
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }

foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {

        $regHKU = @(
            "Registry::$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PDFMaestro"
        )

        foreach ($reg in $regHKU) {
            if (Test-Path $reg) {
                Remove-Item $reg -Recurse -ErrorAction SilentlyContinue
                if (Test-Path $reg) {
                    "Failed to remove PDFMaestro HKU registry key -> $reg"
                }
            }
        }
    }
}

$traceBase = "Registry::HKLM\Software\Microsoft\Tracing"
$traceKeys = Get-ChildItem -Path $traceBase -ErrorAction SilentlyContinue | Where-Object {
    $_.PSChildName -like "PDFMaestro*_RASAPI32" -or $_.PSChildName -like "PDFMaestro*_RASMANCS"
}

foreach ($key in $traceKeys) {
    if (Test-Path $key.PSPath) {
        Remove-Item $key.PSPath -Recurse -ErrorAction SilentlyContinue
    }
}

$traceBaseWow = "Registry::HKLM\Software\WOW6432Node\Microsoft\Tracing"
$traceKeysWow = Get-ChildItem -Path $traceBaseWow -ErrorAction SilentlyContinue | Where-Object {
    $_.PSChildName -like "PDFMaestro*_RASAPI32" -or $_.PSChildName -like "PDFMaestro*_RASMANCS" -or $_.PSChildName -like "PDFMaestroSetup*_RASAPI32" -or $_.PSChildName -like "PDFMaestroSetup*_RASMANCS"
}

foreach ($key in $traceKeysWow) {
    if (Test-Path $key.PSPath) {
        Remove-Item $key.PSPath -Recurse -ErrorAction SilentlyContinue
    }
}
