Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$users = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $users) {
    if ($user -notlike "*Public*") {
        $exists = test-path "C:\Users\$user\AppData\Roaming\Browser Assistant"
        if ($exists -eq $True) {
            rm "C:\Users\$user\AppData\Roaming\Browser Assistant" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$user\AppData\Roaming\Browser Assistant"
            if ($exists -eq $True) {
                "Browser Assistant Removal Unsuccessful => C:\Users\$user\AppData\Roaming\Browser Assistant" 
            }
        }
        $exists2 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\BrowserAssistant.lnk"
        if ($exists2 -eq $True) {
            rm "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\BrowserAssistant.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\BrowserAssistant.lnk"
            if ($exists2 -eq $True) {
                "Browser Assistant Removal Unsuccessful => C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\BrowserAssistant.lnk" 
            }
        }
        $exists3 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.lnk"
        if ($exists3 -eq $True) {
            rm "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists3 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.lnk"
            if ($exists3 -eq $True) {
                "Browser Assistant Removal Unsuccessful => C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\updater.lnk" 
            }
        }
    }
}

$exists4 = test-path "C:\windows\system32\tasks\BA Scheduler"
    if ($exists4 -eq $True) {
        rm "C:\windows\system32\tasks\BA Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists4 = test-path "C:\windows\system32\tasks\BA Scheduler"
        if ($exists4 -eq $True) {
            "BA Scheduler Removal Unsuccessful => C:\windows\system32\tasks\BA Scheduler" 
    }
}

$exists5 = test-path "C:\windows\system32\tasks\D B Scheduler"
    if ($exists5 -eq $True) {
        rm "C:\windows\system32\tasks\D B Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists5 = test-path "C:\windows\system32\tasks\D B Scheduler"
        if ($exists5 -eq $True) {
            "D B Scheduler Removal Unsuccessful => C:\windows\system32\tasks\D B Scheduler" 
    }
}

$exists6 = test-path "C:\windows\system32\tasks\D Edge C Scheduler"
    if ($exists6 -eq $True) {
        rm "C:\windows\system32\tasks\D Edge C Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists6 = test-path "C:\windows\system32\tasks\D Edge C Scheduler"
        if ($exists6 -eq $True) {
            "D Edge C Scheduler Removal Unsuccessful => C:\windows\system32\tasks\D Edge C Scheduler" 
    }
}

$exists7 = test-path "C:\windows\system32\tasks\Startup Scheduler"
    if ($exists7 -eq $True) {
        rm "C:\windows\system32\tasks\Startup Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists7 = test-path "C:\windows\system32\tasks\Startup Scheduler"
        if ($exists7 -eq $True) {
            "Startup Scheduler Removal Unsuccessful => C:\windows\system32\tasks\Startup Scheduler" 
    }
}

#Check and removal for PCAcceleratorPro registry keys
$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists8 = (Get-Item $regkey).Property -contains "BAStartup"
        if ($exists8 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "BAStartup" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists8 = (Get-Item $regkey).Property -contains "BAStartup"
            if ($exists8 -eq $True) {
                "BAStartup Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.BAStartup"
            }
        }
        $exists9 = (Get-Item $regkey).Property -contains "BAUpdater"
        if ($exists9 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "BAUpdater" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists9 = (Get-Item $regkey).Property -contains "BAUpdater"
            if ($exists9 -eq $True) {
                "BAUpdater Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.BAUpdater"
            }
        }
        $exists10 = test-path -path "Registry::$sid\Software\Realistic Media Inc."
        if ($exists10 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\Realistic Media Inc." -Recurse -ErrorAction SilentlyContinue
            $exists10 = test-path -path "Registry::$sid\Software\Realistic Media Inc."
            if ($exists10 -eq $True) {
                "Realistic Media Inc. Removal Unsuccessful => Registry::$sid\Software\Realistic Media Inc."
            }
        }
    }
}

$exists11 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BA Scheduler"
    if ($exists11 -eq $True) {
        Remove-Item -Path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BA Scheduler" -Recurse -ErrorAction SilentlyContinue
        $exists11 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BA Scheduler"
        if ($exists11 -eq $True) {
            "BA Scheduler Removal Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BA Scheduler"
    }
}

$exists12 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D B Scheduler"
    if ($exists12 -eq $True) {
        Remove-Item -Path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D B Scheduler" -Recurse -ErrorAction SilentlyContinue
        $exists12 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D B Scheduler"
        if ($exists12 -eq $True) {
            "D B Scheduler Removal Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D B Scheduler"
    }
}

$exists13 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D Edge C Scheduler"
    if ($exists13 -eq $True) {
        Remove-Item -Path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D Edge C Scheduler" -Recurse -ErrorAction SilentlyContinue
        $exists13 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D Edge C Scheduler"
        if ($exists13 -eq $True) {
            "D Edge C Scheduler Removal Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\D Edge C Scheduler"
    }
}

$exists14 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Startup Scheduler"
    if ($exists14 -eq $True) {
        Remove-Item -Path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Startup Scheduler" -Recurse -ErrorAction SilentlyContinue
        $exists14 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Startup Scheduler"
        if ($exists14 -eq $True) {
            "Startup Scheduler Removal Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Startup Scheduler"
    }
}
