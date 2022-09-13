Get-Process Cash -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\Cash"
        $exists2 = test-path "C:\users\$i\appdata\roaming\Cash"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\Cash" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\Cash"
            if ($exists -eq $True) {
                "Cash Removal Unsuccessful => C:\users\$i\appdata\local\Cash" 
            }
        } 
        if ($exists2 -eq $True) {
            rm "C:\users\$i\appdata\roaming\Cash" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$i\appdata\roaming\Cash"
            if ($exists2 -eq $True) {
                "Cash Removal Unsuccessful => C:\users\$i\appdata\roaming\Cash"
            }
        } 
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists3 = (Get-Item $regkey).Property -contains "Cash"
        if ($exists3 -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Cash" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists3 = (Get-Item $regkey).Property -contains "Cash"
            if ($exists3 -eq $True) {
                "Cash Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.Cash"
            }
        }
    }
}
