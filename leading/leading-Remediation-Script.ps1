Get-Process Leading -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\Leading"
        $exists2 = test-path "C:\users\$i\appdata\roaming\Leading"
        $exists4 = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Leading.lnk"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\Leading" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\Leading"
            if ($exists -eq $True) {
                "Leading Removal Unsuccessful => C:\users\$i\appdata\local\Leading" 
            }
        } 
        if ($exists2 -eq $True) {
            rm "C:\users\$i\appdata\roaming\Leading" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$i\appdata\roaming\Leading"
            if ($exists2 -eq $True) {
                "Leading Removal Unsuccessful => C:\users\$i\appdata\roaming\Leading"
            }
        }
            if ($exists4 -eq $True) {
            rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Leading.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists4 = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Leading.lnk"
            if ($exists4 -eq $True) {
               "Leading Removal Unsuccessful => C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Leading.lnk"
             }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists3 = (Get-Item $regkey).Property -contains "Leading"
        if ($exists3 -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Leading" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists3 = (Get-Item $regkey).Property -contains "Leading"
            if ($exists3 -eq $True) {
                "Leading Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.Leading"
            }
        }
    }
}
