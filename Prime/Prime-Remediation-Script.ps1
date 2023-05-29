Get-Process Prime -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\Prime"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\Prime" -Force -Recurse -ErrorAction SilentlyContinue 
            $exist = test-path "C:\users\$i\appdata\local\Prime"
            if ($exists -eq $True) {
                "Prime Removal Unsuccessful => C:\users\$i\appdata\local\Prime" 
            }
        } 
        $exists = test-path "C:\users\$i\appdata\roaming\Prime"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\roaming\Prime" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\roaming\Prime"
            if ($exists -eq $True) {
                "Prime Removal Unsuccessful => C:\users\$i\appdata\roaming\Prime"
            }
        } 
        $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\prime.lnk"
        if ($exists -eq $True) {
            rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\prime.lnk" -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\prime.lnk"
            if ($exists -eq $True) {
                "Prime Removal Unsuccessful => C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\prime.lnk"
            }
        } 
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists = (Get-Item $regkey).Property -contains "Prime"
        if ($exists -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Prime" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists = (Get-Item $regkey).Property -contains "Prime"
            if ($exists -eq $True) {
                "Prime Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.Prime"
            }
        }
    }
}
