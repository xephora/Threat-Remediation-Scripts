$process = Get-Process "PDFunk" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    $file_paths = @(
        "C:\Users\$user\AppData\Local\PDFunk",
        "C:\Users\$user\AppData\Roaming\PDFunk",
        "C:\Users\$user\AppData\Local\pdfunk-updater",
        "C:\Users\$user\AppData\Local\Programs\PDFunk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PDFunk.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PDFunk.lnk"
    )
    foreach ($path in $file_paths) {
        if (Test-Path $path) {
            Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove PDFunk -> $path"
            }
        }
    }

    $downloads = Get-ChildItem "C:\Users\$user\Downloads\" -Filter "PdfConverters*" -ErrorAction SilentlyContinue
    foreach ($item in $downloads) {
        $fullpath = $item.FullName
        if (Test-Path $fullpath) {
            Remove-Item $fullpath -Force -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $fullpath) {
                "Failed to remove PdfConverters -> $fullpath"
            }
        }
    }
}

# Registry Key Cleanup
$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $uninstall_key = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\98da245b-e554-5838-b247-454aefcb1803"
        if (Test-Path $uninstall_key) {
            Remove-Item $uninstall_key -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $uninstall_key) {
                "Failed to remove PDFunk => $uninstall_key"
            }
        }
    }
}
