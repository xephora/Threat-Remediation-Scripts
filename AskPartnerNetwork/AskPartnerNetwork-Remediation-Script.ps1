Get-Process apnmcp -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process TBNotifier -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {

    if ($i -notlike "*Public*") {
        rm "C:\users\$i\appdata\local\AskPartnerNetwork" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    }
}

rm "C:\Program Files (x86)\AskPartnerNetwork" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\programdata\AskPartnerNetwork" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\programdata\apn" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        Remove-Item -Path Registry::$i\Software\AskPartnerNetwork -Recurse -ErrorAction SilentlyContinue
    }
}

Remove-Item -Path Registry::HKLM\Software\AskPartnerNetwork -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path Registry::HKLM\SOFTWARE\WOW6432NODE\AskPartnerNetwork -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path Registry::HKLM\SYSTEM\CURRENTCONTROLSET\SERVICES\APNMCP -Recurse -ErrorAction SilentlyContinue
Remove-ItemProperty -Path Registry::HKLM\SOFTWARE\WOW6432NODE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN -Name ApnTBMon -ErrorAction SilentlyContinue

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
	    $result = test-path -Path "C:\users\$i\appdata\local\AskPartnerNetwork"
        if ($result -eq "True") {
            "AskPartnerNetwork wasn't removed => on C:\users\$i\appdata\local\AskPartnerNetwork"
        }
    }
}

$result = test-path -Path "C:\Program Files (x86)\AskPartnerNetwork"
if ($result -eq "True") {
	"AskPartnerNetwork wasn't removed => on C:\Program Files (x86)\AskPartnerNetwork"
}

$result = test-path -Path "C:\programdata\AskPartnerNetwork"
if ($result -eq "True") {
	"AskPartnerNetwork wasn't removed => on C:\programdata\AskPartnerNetwork"
}

$result = test-path -Path "C:\programdata\apn"
if ($result -eq "True") {
	"AskPartnerNetwork wasn't removed => on C:\programdata\apn"
}


$result = test-path -Path Registry::HKLM\SOFTWARE\WOW6432NODE\AskPartnerNetwork
if ($result -eq "True") {
	"AskPartnerNetwork wasn't removed => on HKLM\SOFTWARE\WOW6432NODE\AskPartnerNetwork"
}
