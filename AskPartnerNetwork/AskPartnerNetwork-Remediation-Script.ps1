Get-Process apnmcp -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process TBNotifier -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if (test-path -Path "C:\Users\$i\appdata\local\AskPartnerNetwork") {
        rm "C:\Users\$i\appdata\local\AskPartnerNetwork" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\local\AskPartnerNetwork") {
            "Failed to remove AskPartnerNetwork -> C:\Users\$i\appdata\local\AskPartnerNetwork"
        }
    }
}

if (test-path "C:\Program Files (x86)\AskPartnerNetwork") {
    Remove-Item -Path "C:\Program Files (x86)\AskPartnerNetwork" -Recurse -ErrorAction SilentlyContinue
    if (test-path "C:\Program Files (x86)\AskPartnerNetwork") {
        "Failed to remove AskPartnerNetwork -> C:\Program Files (x86)\AskPartnerNetwork"
    }
}

if (test-path "C:\Program Files\AskPartnerNetwork") {
    Remove-Item -Path "C:\Program Files\AskPartnerNetwork" -Recurse -ErrorAction SilentlyContinue
    if (test-path "C:\Program Files\AskPartnerNetwork") {
        "Failed to remove AskPartnerNetwork -> C:\Program Files\AskPartnerNetwork"
    }
}

if (test-path "C:\programdata\AskPartnerNetwork") {
    Remove-Item -Path "C:\programdata\AskPartnerNetwork" -Recurse -ErrorAction SilentlyContinue
    if (test-path "C:\programdata\AskPartnerNetwork") {
        "Failed to remove AskPartnerNetwork -> C:\programdata\AskPartnerNetwork"
    }
}

if (test-path "C:\programdata\apn") {
    Remove-Item -Path "C:\programdata\apn" -Recurse -ErrorAction SilentlyContinue
    if (test-path "C:\programdata\apn") {
        "Failed to remove AskPartnerNetwork -> C:\programdata\apn"
    }
}

if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov') {
    Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov' -Recurse -ErrorAction SilentlyContinue
    if (test-path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov') {
        "Failed to remove AskPartnerNetwork -> Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov"
    }
}

if (test-path "Registry::HKLM\Software\AskPartnerNetwork") {
    Remove-Item -Path "Registry::HKLM\Software\AskPartnerNetwork" -Recurse -ErrorAction SilentlyContinue
    if (test-path "Registry::HKLM\Software\AskPartnerNetwork") {
        "Failed to remove AskPartnerNetwork -> Registry::HKLM\Software\AskPartnerNetwork"
    }
}

if (test-path "Registry::HKLM\SOFTWARE\WOW6432NODE\AskPartnerNetwork") {
    Remove-Item -Path "Registry::HKLM\SOFTWARE\WOW6432NODE\AskPartnerNetwork" -Recurse -ErrorAction SilentlyContinue
    if (test-path "Registry::HKLM\SOFTWARE\WOW6432NODE\AskPartnerNetwork") {
        "Failed to remove AskPartnerNetwork -> Registry::HKLM\SOFTWARE\WOW6432NODE\AskPartnerNetwork"
    }
}

if (test-path "Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP") {
    Remove-Item -Path "Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP" -Recurse -ErrorAction SilentlyContinue
    if (test-path "Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP") {
        "Failed to remove AskPartnerNetwork -> Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP"
    }
}

if (test-path "Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP") {
    Remove-Item -Path "Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP" -Recurse -ErrorAction SilentlyContinue
    if (test-path "Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP") {
        "Failed to remove AskPartnerNetwork -> Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP"
    }
}

if (test-path "Registry::HKLM\SOFTWARE\WOW6432NODE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN"){
    $keypath = "Registry::HKLM\SOFTWARE\WOW6432NODE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN"
    $keyexists = (Get-Item $keypath).Property -contains "ApnTBMon"
    if ($keyexists -eq $True) {
        Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "ApnTBMon" -ErrorAction SilentlyContinue
        $keyexists = (Get-Item $keypath).Property -contains "ApnTBMon"
        if ($keyexists -eq $True) {
            "Failed to remove AskPartnerNetwork => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.ApnTBMon"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $keyexists = test-path -path "Registry::$i\Software\AskPartnerNetwork"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\AskPartnerNetwork" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\AskPartnerNetwork"
            if ($keyexists -eq $True) {
                "Failed to remove AskPartnerNetwork => Registry::$i\Software\AskPartnerNetwork"
            }
        }
    }
}
