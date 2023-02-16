Get-Process SecureBrowserCrashHandler -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process SecureBrowserCrashHandler64 -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$users = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $users) {
    if ($user -notlike "*Public*") {
        $exists = test-path "C:\Users\$user\AppData\Roaming\BBSK"
        if ($exists -eq $True) {
            rm "C:\Users\$user\AppData\Roaming\BBSK" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$user\AppData\Roaming\BBSK"
            if ($exists -eq $True) {
                "BBSK Removal Unsuccessful => C:\Users\$user\AppData\Roaming\BBSK" 
            }
        }
        $exists19 = test-path "C:\Users\$user\AppData\Roaming\Blaze Media Inc"
        if ($exists19 -eq $True) {
            rm "C:\Users\$user\AppData\Roaming\Blaze Media Inc" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists19 = test-path "C:\Users\$user\AppData\Roaming\Blaze Media Inc"
            if ($exists19 -eq $True) {
                "BBSK Removal Unsuccessful => C:\Users\$user\AppData\Roaming\Blaze Media Inc" 
            }
        }
        $exists2 = test-path "C:\users\$user\appdata\local\BlazeMedia"
        if ($exists2 -eq $True) {
            rm "C:\users\$user\appdata\local\BlazeMedia" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$user\appdata\local\BlazeMedia"
            if ($exists2 -eq $True) {
                $exists20 = test-path "C:\Users\$user\AppData\Local\BlazeMedia\SecureBrowser\Application\chrome.exe"
                if ($exists20 -eq $True){
                    Get-Process Chrome -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                    rm "C:\Users\$user\AppData\Local\BlazeMedia"
                    $exists20 = test-path "C:\Users\$user\AppData\Local\BlazeMedia\"    
                    if ($exists20 -eq $True) {
                        "BBSK Removal Unsuccessful => C:\users\$user\appdata\local\BlazeMedia"
                    }
                }
            }
        }
        $exists3 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Secure Browser.lnk"
        if ($exists3 -eq $True) {
            rm "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Secure Browser.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists3 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Secure Browser.lnk"
            if ($exists3 -eq $True) {
                "BBSK Removal Unsuccessful => C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Secure Browser.lnk"
            }
         }
    }
}

$exists4 = test-path "C:\windows\system32\tasks\BB Updater Scheduler"
if ($exists4 -eq $True) {
    rm "C:\windows\system32\tasks\BB Updater Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists4 = test-path "C:\windows\system32\tasks\BB Updater Scheduler"
    if ($exists4 -eq $True) {
        "BBSK Removal Unsuccessful => C:\windows\system32\tasks\BB Updater Scheduler"
    }
}

$exists5 = test-path "C:\windows\system32\tasks\BBSK Startup Scheduler"
if ($exists5 -eq $True) {
    rm "C:\windows\system32\tasks\BBSK Startup Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists5 = test-path "C:\windows\system32\tasks\BBSK Startup Scheduler"
    if ($exists5 -eq $True) {
        "BBSK Removal Unsuccessful => C:\windows\system32\tasks\BBSK Startup Scheduler"
    }
}

$exists6 = test-path "C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*Core"
if ($exists6 -eq $True) {
    rm "C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists6 = test-path "C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*Core"
    if ($exists6 -eq $True) {
        "BBSK Removal Unsuccessful => C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*Core"
    }
}

$exists7 = test-path "C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*ua"
if ($exists7 -eq $True) {
    rm "C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists7 = test-path "C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*ua"
    if ($exists7 -eq $True) {
        "BBSK Removal Unsuccessful => C:\windows\system32\tasks\BlazeMediaUpdateTaskUser*Core"
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists8 = (Get-Item $regkey).Property -contains "BBUpdaterStartup"
        if ($exists8 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "BBUpdaterStartup" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists8 = (Get-Item $regkey).Property -contains "BBUpdaterStartup"
            if ($exists8 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.BBUpdaterStartup"
            }
        }
        $exists9 = (Get-Item $regkey).Property -contains "SKStartup"
        if ($exists9 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "SKStartup" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists9 = (Get-Item $regkey).Property -contains "SKStartup"
            if ($exists9 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.SKStartup"
            }
        }
        $exists10 = (Get-Item $regkey).Property -contains "SKUpdater"
        if ($exists10 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "SKUpdater" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists10 = (Get-Item $regkey).Property -contains "SKUpdater"
            if ($exists10 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.SKUpdater"
            }
        }
        $exists21 = (Get-Item $regkey).Property -contains "BlazeMedia Update"
        if ($exists21 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "BlazeMedia Update" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists21 = (Get-Item $regkey).Property -contains "BlazeMedia Update"
            if ($exists21 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.BlazeMedia Update"
            }
        }
        $exists11 = test-path -path "Registry::$sid\Software\BlazeMedia"
        if ($exists11 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\BlazeMedia" -Recurse -ErrorAction SilentlyContinue
            $exists11 = test-path -path "Registry::$sid\Software\BlazeMedia"
            if ($exists11 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\BlazeMedia"
            }
        }
        $exists12 = test-path -path "Registry::$sid\Software\Blaze Media Inc"
        if ($exists12 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\Blaze Media Inc" -Recurse -ErrorAction SilentlyContinue
            $exists12 = test-path -path "Registry::$sid\Software\Blaze Media Inc"
            if ($exists12 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Blaze Media Inc"
            }
        }
        $exists13 = test-path -path "Registry::$sid\Software\Drake Media Inc."
        if ($exists13 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\Drake Media Inc." -Recurse -ErrorAction SilentlyContinue
            $exists13 = test-path -path "Registry::$sid\Software\Drake Media Inc."
            if ($exists13 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Drake Media Inc."
            }
        }
        $exists14 = test-path -path "Registry::$sid\Software\Clients\StartMenuInternet\Secure Browser*"
        if ($exists14 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\Clients\StartMenuInternet\Secure Browser*" -Recurse -ErrorAction SilentlyContinue
            $exists14 = test-path -path "Registry::$sid\Software\Clients\StartMenuInternet\Secure Browser*"
            if ($exists14 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Clients\StartMenuInternet\Secure Browser*"
            }
        }
        $exists15 = test-path -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\BlazeMedia SecureBrowser"
        if ($exists15 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\BlazeMedia SecureBrowser" -Recurse -ErrorAction SilentlyContinue
            $exists15 = test-path -path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\BlazeMedia SecureBrowser"
            if ($exists15 -eq $True) {
                "BBSK Removal Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\BlazeMedia SecureBrowser"
            }
        }
    }
}

$exists16 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BB Updater Scheduler"
if ($exists16 -eq $True) {
    rm "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BB Updater Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists16 = test-path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BB Updater Scheduler"
    if ($exists16 -eq $True) {
        "BBSK Removal Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BB Updater Scheduler"
    }
}

$exists17 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BBSK Startup Scheduler"
if ($exists17 -eq $True) {
    rm "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BBSK Startup Scheduler" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists17 = test-path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BBSK Startup Scheduler"
    if ($exists17 -eq $True) {
        "BBSK Removal Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BBSK Startup Scheduler"
    }
}

$exists18 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BlazeMediaUpdateTaskUser*"
if ($exists18 -eq $True) {
    rm "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BlazeMediaUpdateTaskUser*" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists18 = test-path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BlazeMediaUpdateTaskUser*"
    if ($exists18 -eq $True) {
        "BBSK Removal Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\BlazeMediaUpdateTaskUser*"
    }
}
