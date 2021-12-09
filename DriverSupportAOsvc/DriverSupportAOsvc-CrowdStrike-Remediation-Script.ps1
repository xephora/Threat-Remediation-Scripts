# Removal

Get-Process DriverSupport -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process DriverSupportAO -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process DriverSupportAOsvc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\users\$i\appdata\local\PC_Drivers_Headquarters" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    }
}

rm "C:\programdata\Driver Support" -Force -Recurse -ErrorAction SilentlyContinue
rm "C:\program files (x86)\Driver Support" -Force -Recurse -ErrorAction SilentlyContinue
rm "C:\program files\Driver Support" -Force -Recurse -ErrorAction SilentlyContinue

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        Remove-Item -Path Registry::$j\Software\DriverSupport -Recurse -ErrorAction SilentlyContinue
    }
}

Remove-Item -Path Registry::HKLM\SOFTWARE\WOW6432Node\ActiveOptimization -Recurse -ErrorAction SilentlyContinue

# Check Removal

$result = test-path -Path "C:\program files (x86)\Driver Support"
if ($result -eq "True") {
	"DriverSupportAOsvc wasn't removed => on C:\Program Files (x86)\Driver Support"
}

$result = test-path -Path "C:\programdata\Driver Support"
if ($result -eq "True") {
	"DriverSupportAOsvc wasn't removed => on C:\programdata\Driver Support"
}

$result = test-path -Path "C:\program files\Driver Support"
if ($result -eq "True") {
	"DriverSupportAOsvc wasn't removed => on C:\program files\Driver Support"
}

$result = test-path -Path Registry::HKLM\SOFTWARE\WOW6432Node\ActiveOptimization
if ($result -eq "True") {
	"DriverSupportAOsvc registry key wasn't removed => HKLM\SOFTWARE\WOW6432Node\ActiveOptimization"
}
