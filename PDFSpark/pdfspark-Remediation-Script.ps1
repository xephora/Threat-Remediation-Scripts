$process = Get-Process "PDF Spark" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
$process = Get-Process "Spark*" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Users\$user\Downloads\Spark*.exe",
            "C:\Users\$user\AppData\Local\Programs\PDF Spark",
            "C:\Users\$user\AppData\Roaming\pdf-spark-nativefier*",
            "C:\Users\$user\Desktop\PDF Spark.lnk",
            "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PDF Spark.lnk"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove PDF Spark -> $path"
                }
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $uninstallKey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\PDF Spark_is1"
        if (Test-Path $uninstallKey) {
            Remove-Item $uninstallKey -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $uninstallKey) {
                Write-Host "Failed to remove PDF Spark -> $uninstallKey"
            }
        }
    }
}

$ldapServicePath = "Registry::HKLM\SYSTEM\ControlSet001\Services\LDAP"
if (Test-Path $ldapServicePath) {
    Get-ChildItem $ldapServicePath | Where-Object { $_.Name -like "*SparkOnSoft*" } | ForEach-Object {
        $sparkServicePath = $_.PsPath
        Remove-Item -Path $sparkServicePath -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $sparkServicePath) {
            Write-Host "Failed to remove SparkOnSoft service -> $sparkServicePath"
        } else {
            Write-Host "Removed SparkOnSoft service -> $sparkServicePath"
        }
    }
}
