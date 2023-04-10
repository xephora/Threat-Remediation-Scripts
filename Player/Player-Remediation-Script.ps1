Get-Process player -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\player"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\player" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\player"
            if ($exists -eq $True) {
                "player Removal Unsuccessful => C:\users\$i\appdata\local\player" 
            }
        }
        $exists = test-path "C:\users\$i\appdata\roaming\player" 
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\roaming\player" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\roaming\player"
            if ($exists -eq $True) {
                "player Removal Unsuccessful => C:\users\$i\appdata\roaming\player"
            }
        } 
        $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\player.lnk"
        if ($exists -eq $True) {
        rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\player.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\player.lnk"
        if ($exists -eq $True) {
            "player.lnk Removal Unsuccessful => C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\player.lnk"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists = (Get-Item $regkey).Property -contains "player"
        if ($exists -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "player" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists = (Get-Item $regkey).Property -contains "player"
            if ($exists -eq $True) {
                "player Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.player"
            }
        }
    }
}
