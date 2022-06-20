Get-Process Prime -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\Prime"
        $exists2 = test-path "C:\users\$i\appdata\roaming\Prime"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\Prime" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\Prime"
            if ($exists -eq $True) {
                "Prime Removal Unsuccessful => C:\users\$i\appdata\local\Prime" 
            }
        } 
        if ($exists2 -eq $True) {
            rm "C:\users\$i\appdata\roaming\Prime" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$i\appdata\roaming\Prime"
            if ($exists2 -eq $True) {
                "Prime Removal Unsuccessful => C:\users\$i\appdata\roaming\Prime"
            }
        } 
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists3 = (Get-Item $regkey).Property -contains "Prime"
        if ($exists3 -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Prime" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists3 = (Get-Item $regkey).Property -contains "Prime"
            if ($exists3 -eq $True) {
                "Prime Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.Prime"
            }
        }
    }
}
