Get-Process gallery -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\gallery"
        $exists2 = test-path "C:\users\$i\appdata\roaming\gallery"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\gallery" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\gallery"
            if ($exists -eq $True) {
                "gallery Removal Unsuccessful => C:\users\$i\appdata\local\gallery" 
            }
        } 
        if ($exists2 -eq $True) {
            rm "C:\users\$i\appdata\roaming\gallery" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$i\appdata\roaming\gallery"
            if ($exists2 -eq $True) {
                "gallery Removal Unsuccessful => C:\users\$i\appdata\roaming\gallery"
            }
        } 
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists3 = (Get-Item $regkey).Property -contains "gallery"
        if ($exists3 -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "gallery" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists3 = (Get-Item $regkey).Property -contains "gallery"
            if ($exists3 -eq $True) {
                "gallery Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.gallery"
            }
        }
    }
}
