Get-Process Healthy -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\Healthy"
        $exists2 = test-path "C:\users\$i\appdata\roaming\Healthy"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\Healthy" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\Healthy"
            if ($exists -eq $True) {
                "Healthy Removal Unsuccessful => C:\users\$i\appdata\local\Healthy" 
            }
        } 
        if ($exists2 -eq $True) {
            rm "C:\users\$i\appdata\roaming\Healthy" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$i\appdata\roaming\Healthy"
            if ($exists2 -eq $True) {
                "Healthy Removal Unsuccessful => C:\users\$i\appdata\roaming\Healthy"
            }
        } 
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists3 = (Get-Item $regkey).Property -contains "Healthy"
        if ($exists3 -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Healthy" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists3 = (Get-Item $regkey).Property -contains "Healthy"
            if ($exists3 -eq $True) {
                "Healthy Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.Healthy"
            }
        }
    }
}
