Get-Process ElevenClock -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\AppData\Local\Programs\ElevenClock"
        $exists2 = test-path "C:\users\$i\.elevenclock"
        if ($exists -eq $True) {
            rm "C:\users\$i\AppData\Local\Programs\ElevenClock" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\AppData\Local\Programs\ElevenClock"
            if ($exists -eq $True) {
                "elevenClock Removal Unsuccessful => C:\users\$i\AppData\Local\Programs\ElevenClock" 
            }
        } 
        if ($exists2 -eq $True) {
            rm "C:\users\$i\.elevenclock" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$i\.elevenclock"
            if ($exists2 -eq $True) {
                "elevenClock Removal Unsuccessful => C:\users\$i\.elevenclock"
            }
        } 
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists3 = (Get-Item $regkey).Property -contains "elevenClock"
        if ($exists3 -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "elevenClock" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists3 = (Get-Item $regkey).Property -contains "elevenClock"
            if ($exists3 -eq $True) {
                "elevenClock Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.elevenClock"
            }
        }
    }
}
