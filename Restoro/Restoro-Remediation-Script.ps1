Get-Process RestoroProtection -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process RestoroService -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

stop-service RestoroActiveProtection -force -ErrorAction SilentlyContinue
$service = Get-WmiObject -Class Win32_Service -Filter "Name='RestoroActiveProtection'"
if ($service) {
	$service.delete()
}

if (test-path -Path 'C:\ProgramData\Restoro') {
    Remove-Item -Path 'C:\ProgramData\Restoro' -Recurse -ErrorAction SilentlyContinue
    if (test-path -Path 'C:\ProgramData\Restoro') {
        "Failed to remove restoro -> C:\ProgramData\Restoro"
    }
}

if (test-path -Path 'Registry::HKLM\Software\Restoro') {
    Remove-Item -Path 'Registry::HKLM\Software\Restoro' -Recurse -ErrorAction SilentlyContinue
    if (test-path -Path 'Registry::HKLM\Software\Restoro') {
        "Failed to remove Restoro -> Registry::HKLM\Software\Restoro"
    }
}

if (test-path -Path 'Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Restoro') {
    Remove-Item -Path 'Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Restoro' -Recurse -ErrorAction SilentlyContinue
    if (test-path -Path 'Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Restoro') {
        "Failed to remove Restoro -> Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Restoro"
    }
}

$keypath = "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
$keyexists = (Get-Item $keypath).Property -contains "Restoro"
if ($keyexists -eq $True) {
    Remove-ItemProperty -Path "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Restoro" -ErrorAction SilentlyContinue
    $keyexists = (Get-Item $keypath).Property -contains "Restoro"
    if ($keyexists -eq $True) {
        "Failed to remove Restoro => Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Run.Restoro"
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        if (test-path -path "Registry::$i\Software\Restoro") {
            Remove-Item -Path "Registry::$i\Software\Restoro" -Recurse -ErrorAction SilentlyContinue
            if (test-path -path "Registry::$i\Software\Restoro") {
                "Failed to remove Restoro -> Registry::$i\Software\Restoro"
            }
        }
        if (test-path -path "Registry::$i\Software\Restoro Key") {
            Remove-Item -Path "Registry::$i\Software\Restoro Key" -Recurse -ErrorAction SilentlyContinue
            if (test-path -path "Registry::$i\Software\Restoro Key") {
                "Failed to remove Restoro -> Registry::$i\Software\Restoro Key"
            }
        }
    }
}
