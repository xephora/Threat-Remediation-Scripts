Get-Process AweAPCP -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process RAweAPCP -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$users = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $users) {
    if ($user -notlike "*Public*") {
        $exists = test-path "C:\Users\$user\appdata\local\AweAPCP"
        if ($exists -eq $True) {
            rm "C:\Users\$user\appdata\local\AweAPCP" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$user\appdata\local\AweAPCP"
            if ($exists -eq $True) {
                "AweAPCP Removal Unsuccessful => C:\Users\$user\appdata\local\AweAPCP" 
            }
        }
        $exists2 = test-path "C:\Users\$user\appdata\local\MBAweAPCP"
        if ($exists2 -eq $True) {
            rm "C:\Users\$user\appdata\local\MBAweAPCP" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\Users\$user\appdata\local\MBAweAPCP"
            if ($exists2 -eq $True) {
                "MBAweAPCP Removal Unsuccessful => C:\Users\$user\appdata\local\MBAweAPCP" 
            }
        }
    }
}

$exists3 = test-path "C:\ProgramData\AweAPCP"
    if ($exists3 -eq $True) {
        rm "C:\ProgramData\AweAPCP" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists3 = test-path "C:\ProgramData\AweAPCP"
        if ($exists3 -eq $True) {
            "AweAPCP Removal Unsuccessful => C:\ProgramData\AweAPCP" 
    }
}

$exists4 = test-path "C:\Program Files (x86)\MBAweAPCP"
    if ($exists4 -eq $True) {
        rm "C:\Program Files (x86)\MBAweAPCP" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists4 = test-path "C:\Program Files (x86)\MBAweAPCP"
        if ($exists4 -eq $True) {
            "MBAweAPCP Removal Unsuccessful => C:\Program Files (x86)\MBAweAPCP" 
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists5 = (Get-Item $regkey).Property -contains "AweAPCP"
        if ($exists5 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AweAPCP" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists5 = (Get-Item $regkey).Property -contains "AweAPCP"
            if ($exists5 -eq $True) {
                "AweAPCP Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.AweAPCP"
            }
        }
        $exists6 = test-path -path "Registry::$sid\Software\APCTab"
        if ($exists6 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\APCTab" -Recurse -ErrorAction SilentlyContinue
            $exists6 = test-path -path "Registry::$sid\Software\APCTab"
            if ($exists6 -eq $True) {
                "APCTab Removal Unsuccessful => Registry::$sid\Software\APCTab"
            }
        }
        $exists7 = test-path -path "Registry::$sid\Software\NSpeedUpTab"
        if ($exists7 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\NSpeedUpTab" -Recurse -ErrorAction SilentlyContinue
            $exists7 = test-path -path "Registry::$sid\Software\NSpeedUpTab"
            if ($exists7 -eq $True) {
                "NSpeedUpTab Removal Unsuccessful => Registry::$sid\Software\NSpeedUpTab"
            }
        }
    }
}
