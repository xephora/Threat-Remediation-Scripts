Get-Process framework -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\framework"
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\framework" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\framework"
            if ($exists -eq $True) {
                "framework Removal Unsuccessful => C:\users\$i\appdata\local\framework" 
            }
        }
        $exists = test-path "C:\users\$i\appdata\roaming\framework" 
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\roaming\framework" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\roaming\framework"
            if ($exists -eq $True) {
                "framework Removal Unsuccessful => C:\users\$i\appdata\roaming\framework"
            }
        } 
        $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\framework.lnk"
        if ($exists -eq $True) {
            rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\framework.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\framework.lnk"
            if ($exists -eq $True) {
                "framework.lnk Removal Unsuccessful => C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\framework.lnk"
            }
        }
        $exists = test-path "C:\Users\$i\AppData\local\VLC"
        if ($exists -eq $True) {
            rm "C:\Users\$i\AppData\local\VLC" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$i\AppData\local\VLC"
            if ($exists -eq $True) {
                "framework.lnk Removal Unsuccessful => C:\Users\$i\AppData\local\VLC"
            }
        }
        $exists = test-path "C:\Users\$i\appdata\roaming\vlc"
        if ($exists -eq $True) {
            rm "C:\Users\$i\appdata\roaming\vlc" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$i\appdata\roaming\vlc"
            if ($exists -eq $True) {
                "framework.lnk Removal Unsuccessful => C:\Users\$i\appdata\roaming\vlc"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists = (Get-Item $regkey).Property -contains "framework"
        if ($exists -eq $True) {
            Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "framework" -ErrorAction SilentlyContinue
            $regkey = "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists = (Get-Item $regkey).Property -contains "framework"
            if ($exists -eq $True) {
                "framework Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run.framework"
            }
        }
    }
}

$exists = test-path "C:\WINDOWS\system32\config\systemprofile\AppData\Roaming\framework"
if ($exists -eq $True) {
    rm "C:\WINDOWS\system32\config\systemprofile\AppData\Roaming\framework" -Force -Recurse -ErrorAction SilentlyContinue
    $exists = test-path "C:\WINDOWS\system32\config\systemprofile\AppData\Roaming\framework"
    if ($exists -eq $True) {
        "Framework Removal Unsuccessful -> C:\WINDOWS\system32\config\systemprofile\AppData\Roaming\framework"
    }
}
