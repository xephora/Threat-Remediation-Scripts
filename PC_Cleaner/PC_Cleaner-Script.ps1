Get-Process PC_Cleaner -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process PCCNotifications -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$exists = test-path "C:\ProgramData\PC Cleaner"
if ($exists -eq $True) {
    rm "C:\ProgramData\PC Cleaner"-force -Recurse -ErrorAction SilentlyContinue
}

$exists = test-path "C:\windows\system32\tasks\PC Cleaner automatic scan and notifications"
if ($exists -eq $True) {
    rm "C:\windows\system32\tasks\PC Cleaner automatic scan and notifications" -ErrorAction SilentlyContinue
}

$users = (Get-Item C:\users\* | where {$_.PSIsContainer} | select name).name
foreach ($user in $users) {
    if ($user -notlike "*Public*") { 
        rm "C:\users\$user\Downloads\PC_Cleaner.exe" -ErrorAction SilentlyContinue
        $exists = test-path "C:\Users\$user\appdata\roaming\PC Cleaner"
        if ($exists -eq $True) {
            rm "C:\Users\$user\appdata\roaming\PC Cleaner" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$user\appdata\roaming\PC Cleaner"
            if ($exists -eq $True) {
                "PC Cleaner Unsuccessful => C:\Users\$user\appdata\roaming\PC Cleaner"
            }
        } 
    }
}

$sids = Get-Item -Path "Registry::HKU\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($sid in $sids) {
    if ($sid -notlike "*_Classes*") {
    	$exists = test-path "Registry::$sid\Software\PC Cleaner"
        if ($exists -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\PC Cleaner" -ErrorAction SilentlyContinue
    	    $exists = test-path "Registry::$sid\Software\PC Cleaner"
            if ($exists -eq $True) {
                "PC Cleaner Removal Unsuccessful => Registry::$sid\Software\PC Cleaner"
            }
        }
        $exists = test-path "Registry::$sid\Software\PC HelpSoft Driver Updater" -ErrorAction SilentlyContinue
        if ($exists -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\PC HelpSoft Driver Updater" -ErrorAction SilentlyContinue
            $exists = test-path "Registry::$sid\Software\PC HelpSoft Driver Updater"
            if ($exists -eq $True) {
                "PC Cleaner Removal Unsuccessful => Registry::$sid\Software\PC HelpSoft Driver Updater"
            }
        }
    }
}
