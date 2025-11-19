$process = Get-Process node -ErrorAction SilentlyContinue
if ($process) { 
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    $shortcuts = @(
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\pdftool.lnk",
        "C:\Users\$user\desktop\pdftool.lnk",
        "C:\Users\$user\desktop\pdf.lnk"
    )
    foreach ($shortcut in $shortcuts) {
        if (Test-Path -Path $shortcut) {
            Remove-Item $shortcut -ErrorAction SilentlyContinue
            if (Test-Path -Path $shortcut) {
                "Failed to remove PDFTool -> $shortcut"
            }
        }
    }

    $localPaths = @(
        "C:\Users\$user\AppData\Local\PDFTool",
        "C:\Users\$user\AppData\Local\ExtensionOptimizer"
    )
    foreach ($localPath in $localPaths) {
        if (Test-Path -Path $localPath) {
            Remove-Item $localPath -Force -Recurse -ErrorAction SilentlyContinue
            if (Test-Path -Path $localPath) {
                "Failed to remove PDFTool -> $localPath"
            }
        }
    }
}

$regHKLM = @(
    "Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{7BCFB6E7-3F12-4A55-A4B8-9AE2C65DCA6F}"
)
foreach ($regPath in $regHKLM) {
    if (Test-Path $regPath) {
        Remove-Item -Path $regPath -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $regPath) {
            "Failed to remove PDFTool => $regPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $runPath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        if (Test-Path $runPath) {
            if ((Get-ItemProperty -Path $runPath -Name "PDFToolUpdater" -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $runPath -Name "PDFToolUpdater" -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $runPath -Name "PDFToolUpdater" -ErrorAction SilentlyContinue)) {
                    "Failed to remove PDFTool => $runPath.PDFToolUpdater"
                }
            }
        }

        $notifPath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\RunNotification"
        if (Test-Path $notifPath) {
            if ((Get-ItemProperty -Path $notifPath -Name "StartupTNotiPDFToolUpdater" -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $notifPath -Name "StartupTNotiPDFToolUpdater" -ErrorAction SilentlyContinue
                if ((Get-ItemProperty -Path $notifPath -Name "StartupTNotiPDFToolUpdater" -ErrorAction SilentlyContinue)) {
                    "Failed to remove PDFTool => $notifPath.StartupTNotiPDFToolUpdater"
                }
            }
        }

        $extraRegPaths = @(
            "Registry::$sid\Software\Microsoft\Installer\Products\7E6BFCB721F355A44A8BA92E6CD5ACF6"
        )
        foreach ($path in $extraRegPaths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    "Failed to remove PDFTool => $path"
                }
            }
        }
    }
}
