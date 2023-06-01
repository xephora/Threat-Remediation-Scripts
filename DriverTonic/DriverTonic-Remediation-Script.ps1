Get-Process dtn -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$exists=test-path "C:\ProgramData\drivertonics.com"
if ($exists) {
    rm "C:\ProgramData\drivertonics.com" -Force -Recurse -ErrorAction SilentlyContinue
    $exists=test-path "C:\ProgramData\drivertonics.com"
    if ($exists) {
        "drivertonics removal unsuccessful -> C:\ProgramData\drivertonics.com"
    }
}

$exists=test-path "C:\Users\public\Desktop\Driver Tonic.lnk"
if ($exists) {
    rm "C:\Users\public\Desktop\Driver Tonic.lnk" -ErrorAction SilentlyContinue
    $exists=test-path "C:\Users\public\Desktop\Driver Tonic.lnk"
    if ($exists) {
        "drivertonics removal unsuccessful -> C:\Users\public\Desktop\Driver Tonic.lnk"
    }
}

$exists=test-path "C:\windows\system32\tasks\Driver Tonic_Logon"
if ($exists) {
    rm "C:\windows\system32\tasks\Driver Tonic_Logon" -ErrorAction SilentlyContinue
    $exists=test-path "C:\windows\system32\tasks\Driver Tonic_Logon"
    if ($exists) {
        "drivertonics removal unsuccessful -> C:\windows\system32\tasks\Driver Tonic_Logon"
    }
}

$exists=test-path "Registry::HKLM\Software\drivertonics.com"
if ($exists) {
    remove-item "Registry::HKLM\Software\drivertonics.com" -Recurse -ErrorAction SilentlyContinue
    $exists=test-path "Registry::HKLM\Software\drivertonics.com"
    if ($exists) {
        "drivertonics removal unsuccessful -> Registry::HKLM\Software\drivertonics.com"
    }
}

$exists=test-path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Driver Tonic_Logon"
if ($exists) {
    remove-item "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Driver Tonic_Logon" -Recurse -ErrorAction SilentlyContinue
    $exists=test-path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Driver Tonic_Logon"
    if ($exists) {
        "drivertonics removal unsuccessful -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Driver Tonic_Logon"
    }
}

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\Users\$i\appdata\roaming\drivertonics.com"
        if ($exists -eq $True) {
            rm "C:\Users\$i\appdata\roaming\drivertonics.com" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$i\appdata\roaming\drivertonics.com"
            if ($exists -eq $True) {
                "drivertonics removal unsuccessful => C:\Users\$i\appdata\roaming\drivertonics.com" 
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        $keyexists = test-path -path "Registry::$i\Software\drivertonics.com"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\drivertonics.com" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\drivertonics.com"
            if ($keyexists -eq $True) {
                "WaveBrowser Removal Unsuccessful => Registry::$i\Software\drivertonics.com"
            }
        }
    }
}
