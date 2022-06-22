Get-Process SlimServiceFactory -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process SlimService -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists2 = test-path -path "C:\windows\system32\tasks\SlimCleaner Plus (Scheduled Scan - $i)"
        if ($exists2 -eq $True) {
            rm "C:\windows\system32\tasks\SlimCleaner Plus (Scheduled Scan - $i)" -ErrorAction SilentlyContinue
            $exists2 = test-path -path "C:\windows\system32\tasks\SlimCleaner Plus (Scheduled Scan - $i)"
            if ($exists2 -eq $True) {
                "failed to remove => C:\windows\system32\tasks\SlimCleaner Plus (Scheduled Scan - $i)"
            }
        }
        $exists3 = test-path -path "C:\Users\$i\appdata\local\SlimWare Utilities Inc"
        if ($exists3 -eq $True) {
            rm "C:\Users\$i\appdata\local\SlimWare Utilities Inc" -Force -Recurse -ErrorAction SilentlyContinue
            $exists3 = test-path -path "C:\Users\$i\appdata\local\SlimWare Utilities Inc"
            if ($exists3 -eq $True) {
                "failed to remove => C:\Users\$i\appdata\local\SlimWare Utilities Inc"
            }
        }
    }
}

$exists = test-path -path "C:\Program Files\SlimCleaner Plus"
if ($exists -eq $True) {
    rm "C:\Program Files\SlimCleaner Plus" -Force -Recurse -ErrorAction SilentlyContinue
    $exists = test-path -path "C:\Program Files\SlimCleaner Plus"
    if ($exists -eq $True) {
        "failed to remove => C:\Program Files\SlimCleaner Plus"
    }
}

$exists = test-path -path "C:\ProgramData\SlimWare Utilities Inc"
if ($exists -eq $True) {
    rm "C:\ProgramData\SlimWare Utilities Inc" -Force -Recurse -ErrorAction SilentlyContinue
    $exists = test-path -path "C:\ProgramData\SlimWare Utilities Inc"

    # added a service stop and disable of service 'SlimService', since remove-service cmdlet causes the script to break on CrowdStrike. If you would like this option enabled, feel free to uncomment the below.
    #remove-service -name SlimService -ErrorAction SilentlyContinue # optional, to enable/disable this command, you can add or remove a comment to the beginning of this line.

    # if 'remove-service' cmdlet works, you can comment the two optional commands below.
    Stop-Service -Name "SlimService" -Force -ErrorAction SilentlyContinue # optional, to enable/disable this command, you can add or remove a comment to the beginning of this line.
    Set-Service -Name "SlimService" -Status stopped -StartupType disabled -ErrorAction SilentlyContinue # optional, to enable/disable this command, you can add or remove a comment to the beginning of this line.
    
    if ($exists -eq $True) {
        "failed to remove => C:\ProgramData\SlimWare Utilities Inc"
    }
}

$exists = test-path -path "Registry::HKEY_LOCAL_MACHINE\Software\SlimWare Utilities, Inc."
if ($exists -eq $True) {
    Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\Software\SlimWare Utilities, Inc." -Recurse -ErrorAction SilentlyContinue
    $exists = test-path -path "Registry::HKEY_LOCAL_MACHINE\Software\SlimWare Utilities, Inc."
    if ($exists -eq $True) {
        "failed to remove => Registry::HKEY_LOCAL_MACHINE\Software\SlimWare Utilities, Inc."
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $exists = test-path -path "Registry::$i\Software\SlimWare Utilities Inc"
        if ($exists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\SlimWare Utilities Inc" -Recurse -ErrorAction SilentlyContinue
            $exists = test-path -path "Registry::$i\Software\SlimWare Utilities Inc"
            if ($exists -eq $True) {
                "failed to remove => Registry::$i\Software\SlimWare Utilities Inc"
            }
        }
    }
}
