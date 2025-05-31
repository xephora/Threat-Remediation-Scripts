$process = Get-Process upd -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$process = Get-Process PDFMaker -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$process = Get-Process PDFast -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Users\$user\AppData\Roaming\PDFMaker",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PDFMaker.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PDFast.lnk",
            "C:\users\$user\Downloads\PDFMaker*.exe",
            "C:\users\$user\Downloads\PDFast*.exe",
            "C:\Users\$user\appdata\roaming\PDFast",
            "C:\WINDOWS\system32\config\systemprofile\AppData\Roaming\PDFast"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove PDF Maker -> $path"
                }
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $registryPaths = @(
            "Registry::$sid\Software\PDFMaker",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\PDFMaker 1.0.1",
            "Registry::$sid\Software\Microsoft\Installer\Products\866A81E1E7D4B234D9D920D1BD30209A",
            "Registry::$sid\Software\Caphyon",
            "Registry::$sid\Software\Microsoft\Installer\Products\2869F0CE147ABAD43AAB440DC66A40AD",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\PDFast 1.0.0",
            "Registry::$sid\Software\PDFast",
            "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\$sid\Products\2869F0CE147ABAD43AAB440DC66A40AD",
            "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\PDFast_updater_*",
            "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\$sid\Components")
        foreach ($regPath in $registryPaths) {
            if (Test-Path -Path $regPath) {
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    Write-Host "Failed to remove PDF Maker -> $regPath"
                }
            }
        }
    }
}

$tasks = @(
    "PDFMaker_updater_*",
    "PDFast_updater_*"
)

foreach ($task in $tasks) {
    $taskPath = "C:\windows\system32\tasks\$task"
    if (Test-Path -Path $taskPath) {
        Remove-Item -Path $taskPath -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path -Path $taskPath) {
            Write-Host "Failed to remove PDF Maker task -> $taskPath"
        }
    }
}

$regKeys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\PDFMaker",
    "Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{1E18A668-4D7E-432B-9D9D-021DDB0302A9}",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{A8DE31D4-EF47-4B78-8DAA-BDC58DC79388}",
    "Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{EC0F9682-A741-4DAB-A3BA-44D06CA604DA}"
)
foreach ($regKey in $regKeys) {
    if (Test-Path -Path $regKey) {
        Remove-Item -Path $regKey -Recurse -ErrorAction SilentlyContinue
    }
}

$service = Get-Service -Name '*PDF*' -ErrorAction SilentlyContinue
if ($service) { $service | Stop-Service -Force -ErrorAction SilentlyContinue }

if ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -eq 0) {
    Remove-Service -Name $service -Force -ErrorAction SilentlyContinue
} else {
    Get-WmiObject -Class Win32_Service -Filter "Name='*PDF*'" | Remove-WmiObject
}
