Get-Process music -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\music"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\music" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\music"
            if ($exists -eq $True) {
                "music Removal Unsuccessful => C:\users\$i\appdata\local\music" 
            }
        }
        $exists = test-path "C:\users\$i\appdata\roaming\music" 
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\roaming\music" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\roaming\music"
            if ($exists -eq $True) {
                "music Removal Unsuccessful => C:\users\$i\appdata\roaming\music"
            }
        } 
        $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\music.lnk"
        if ($exists -eq $True) {
        rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\music.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\music.lnk"
        if ($exists -eq $True) {
            "music.lnk Removal Unsuccessful => C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\music.lnk"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists = (Get-Item $regkey).Property -contains "music"
        if ($exists -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "music" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists = (Get-Item $regkey).Property -contains "music"
            if ($exists -eq $True) {
                "music Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.music"
            }
        }
    }
}
