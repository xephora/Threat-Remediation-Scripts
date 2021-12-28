Get-Process IBuddyService -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        Remove-Item -Path Registry::$i\Software\IBuddy -Recurse -ErrorAction SilentlyContinue
    }
}

Remove-Item -Path Registry::HKEY_LOCAL_MACHINE\Software\IBuddy -Recurse -ErrorAction SilentlyContinue

rm "C:\ProgramData\IdleBuddy" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\Program Files (x86)\IBuddy" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError

$result = test-path -Path "C:\ProgramData\IdleBuddy"
if ($result -eq "True") {
	"IBuddy wasn't removed => on C:\ProgramData\IdleBuddy"
}

$result = test-path -Path "C:\Program Files (x86)\IBuddy"
if ($result -eq "True") {
	"IBuddy wasn't removed => on C:\Program Files (x86)\IBuddy"
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $result = test-path -Path Registry::$i\Software\IBuddy
        if ($result -eq "True") {
            "IBuddy registry key wasn't removed => on Registry::$i\Software\WaveBrowser"
        }
    }
}
