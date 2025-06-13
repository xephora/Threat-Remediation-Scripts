$process = Get-Process SGTool -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$process = Get-Process SogouCloud -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$process = Get-Process SogouImeBroker -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$process = Get-Process SOGOUSmartAssistant -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Program Files (x86)\SogouInput",
            "C:\ProgramData\SogouInput",
            "C:\Users\$user\AppData\Local\sogoupdf",
            "C:\users\$user\Downloads\sogou_pinyin*.exe",
            "C:\Users\$user\appdata\local\fastpdf_sogou",
            "C:\Users\$user\appdata\local\kdiskmgr_sogou"
        )

        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove Sogou Adware -> $path"
                }
            }
        }
    }
}

$regKeys = @(
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{CBCBBB2F-1367-4ACA-93FA-3382B1F64F8F}\InprocServer32",
    "Registry::HKLM\SOFTWARE\Classes\CLSID\{801B440B-1EE3-49B0-B05D-2AB076D4E8CB}",
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\sogoudiskmgr",
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\SogouInput"
)

foreach ($regKey in $regKeys) {
    if (Test-Path -Path $regKey) {
        Remove-Item -Path $regKey -Recurse -ErrorAction SilentlyContinue
        if (Test-path -Path $regKey) {
            Write-Host "Failed to remove Sogou Adware -> $regPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $registryPaths = @(
            "Registry::$sid\Software\kdiskmgr_sogou",
            "Registry::$sid\Software\kzip_sogou",
            "Registry::$sid\Software\SogouInput",
            "Registry::$sid\Software\SogouInput.ppup",
            "Registry::$sid\Software\SogouInput.store.user",
            "Registry::$sid\Software\SogouInput.tc",
            "Registry::$sid\Software\sogoupdf",
            "Registry::$sid\Software\SogouInput.user",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\sogoupdf",
            "Registry::$sid\Software\Classes\sogoupdf.exe.pdf",
            "Registry::$($sid)_Classes\sogoupdf.exe.pdf"
        )

        foreach ($regPath in $registryPaths) {
            if (Test-Path -Path $regPath) {
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $regPath) {
                    Write-Host "Failed to remove Sogou Adware -> $regPath"
                }
            }
        }
    }
}
