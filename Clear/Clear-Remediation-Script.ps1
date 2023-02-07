$users = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $users) {
    if ($user -notlike "*Public*") {
        $exists = test-path "C:\Users\$user\AppData\Local\Programs\Clear"
        if ($exists -eq $True) {
            rm "C:\Users\$user\AppData\Local\Programs\Clear" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$user\AppData\Local\Programs\Clear"
            if ($exists -eq $True) {
                "Clear Removal Unsuccessful => C:\Users\$user\AppData\Local\Programs\Clear" 
            }
        }
        $exists2 = test-path "C:\Users\$user\appdata\local\Clear"
        if ($exists2 -eq $True) {
            rm "C:\Users\$user\appdata\local\Clear" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\Users\$user\appdata\local\Clear"
            if ($exists2 -eq $True) {
                "Clear Removal Unsuccessful => C:\Users\$user\appdata\local\Clear"    
            }
        }
        $exists3 = test-path "C:\Users\$user\appdata\local\ClearBrowser"
        if ($exists3 -eq $True) {
            rm "C:\Users\$user\appdata\local\ClearBrowser" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists3 = test-path "C:\Users\$user\appdata\local\ClearBrowser"
            if ($exists3 -eq $True) {
                "ClearBrowser Removal Unsuccessful => C:\Users\$user\appdata\local\ClearBrowser" 
            }
        }
        $exists4 = test-path "C:\Users\$user\downloads\Clear-EasyPrint.*"
        if ($exists4 -eq $True) {
            rm "C:\Users\$user\downloads\Clear-EasyPrint.*" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists4 = test-path "C:\Users\$user\downloads\Clear-EasyPrint.*"
            if ($exists4 -eq $True) {
                "Clear-EasyPrint Removal Unsuccessful => C:\Users\$user\downloads\Clear-EasyPrint.*" 
            }
        }
        $exists20 = test-path "C:\Users\$user\downloads\Clear-TemplateSearch.*"
        if ($exists20 -eq $True) {
            rm "C:\Users\$user\downloads\Clear-TemplateSearch.*" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists20 = test-path "C:\Users\$user\downloads\Clear-TemplateSearch.*"
            if ($exists20 -eq $True) {
                "Clear-TemplateSearch Removal Unsuccessful => C:\Users\$user\downloads\Clear-TemplateSearch.*" 
            }
        }
    }
}

$exists5 = test-path "C:\windows\system32\tasks\ClearbarStartAtLoginTask"
    if ($exists5 -eq $True) {
        rm "C:\windows\system32\tasks\ClearbarStartAtLoginTask" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists5 = test-path "C:\windows\system32\tasks\ClearbarStartAtLoginTask"
        if ($exists5 -eq $True) {
            "ClearbarStartAtLoginTask Removal Unsuccessful => C:\windows\system32\tasks\ClearbarStartAtLoginTask"
    }
}

$exists6 = test-path "C:\windows\system32\tasks\ClearbarUpdateChecker"
    if ($exists6 -eq $True) {
        rm "C:\windows\system32\tasks\ClearbarUpdateChecker" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists6 = test-path "C:\windows\system32\tasks\ClearbarUpdateChecker"
        if ($exists6 -eq $True) {
            "ClearbarUpdateChecker Removal Unsuccessful => C:\windows\system32\tasks\ClearbarUpdateChecker"
    }
}

$exists15 = test-path "C:\windows\system32\tasks\ClearStartAtLoginTask"
    if ($exists15 -eq $True) {
        rm "C:\windows\system32\tasks\ClearStartAtLoginTask" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists15 = test-path "C:\windows\system32\tasks\ClearStartAtLoginTask"
        if ($exists15 -eq $True) {
            "ClearbarUpdateChecker Removal Unsuccessful => C:\windows\system32\tasks\ClearStartAtLoginTask"
    }
}

$exists16 = test-path "C:\windows\system32\tasks\ClearUpdateChecker"
    if ($exists16 -eq $True) {
        rm "C:\windows\system32\tasks\ClearUpdateChecker" -Force -Recurse -ErrorAction SilentlyContinue 
        $exists16 = test-path "C:\windows\system32\tasks\ClearUpdateChecker"
        if ($exists16 -eq $True) {
            "ClearbarUpdateChecker Removal Unsuccessful => C:\windows\system32\tasks\ClearUpdateChecker"
    }
}

#Check and removal for Clear and Clearbar registry keys
$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	$exists7 = (Get-Item $regkey).Property -contains "Clear"
        if ($exists7 -eq $True) {
            Remove-ItemProperty -Path "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Clear" -ErrorAction SilentlyContinue
            $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    	    $exists7 = (Get-Item $regkey).Property -contains "Clear"
            if ($exists7 -eq $True) {
                "Clear Unsuccessful => Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run.Clear"
            }
        }
        $exists14 = test-path -path "Registry::$sid\Software\Clear"
        if ($exists14 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\Clear" -Recurse -ErrorAction SilentlyContinue
            $exists14 = test-path -path "Registry::$sid\Software\Clear"
            if ($exists14 -eq $True) {
                "Clear Removal Unsuccessful => Registry::$sid\Software\Clear"
            }
        }
        $exists8 = test-path -path "Registry::$sid\Software\ClearBar"
        if ($exists8 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\ClearBar" -Recurse -ErrorAction SilentlyContinue
            $exists8 = test-path -path "Registry::$sid\Software\ClearBar"
            if ($exists8 -eq $True) {
                "ClearBar Removal Unsuccessful => Registry::$sid\Software\ClearBar"
            }
        }
        $exists9 = test-path -path "Registry::$sid\Software\ClearBar.App"
        if ($exists9 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\ClearBar.App" -Recurse -ErrorAction SilentlyContinue
            $exists9 = test-path -path "Registry::$sid\Software\ClearBar.App"
            if ($exists9 -eq $True) {
                "ClearBar.App Removal Unsuccessful => Registry::$sid\Software\ClearBar.App"
            }
        }
        $exists10 = test-path -path "Registry::$sid\Software\ClearBrowser"
        if ($exists10 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\ClearBrowser" -Recurse -ErrorAction SilentlyContinue
            $exists10 = test-path -path "Registry::$sid\Software\ClearBrowser"
            if ($exists10 -eq $True) {
                "ClearBrowser Removal Unsuccessful => Registry::$sid\Software\ClearBrowser"
            }
        }
        $exists19 = test-path -path "Registry::$sid\Software\Clear.App"
        if ($exists19 -eq $True) {
            Remove-Item -Path "Registry::$sid\Software\Clear.App" -Recurse -ErrorAction SilentlyContinue
            $exists19 = test-path -path "Registry::$sid\Software\Clear.App"
            if ($exists19 -eq $True) {
                "ClearBrowser Removal Unsuccessful => Registry::$sid\Software\Clear.App"
            }
        }
    }
}

$exists11 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask"
if ($exists11 -eq $True) {
    rm "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists11 = test-path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask"
    if ($exists11 -eq $True) {
        "ClearbarStartAtLoginTask Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarStartAtLoginTask"
    }
}

$exists12 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker"
if ($exists12 -eq $True) {
    rm "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists12 = test-path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker"
    if ($exists12 -eq $True) {
        "ClearbarUpdateChecker Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearbarUpdateChecker"
    }
}

$exists17 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask"
if ($exists17 -eq $True) {
    rm "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists17 = test-path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask"
    if ($exists17 -eq $True) {
        "ClearbarStartAtLoginTask Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearStartAtLoginTask"
    }
}

$exists18 = test-path -path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker"
if ($exists18 -eq $True) {
    rm "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker" -Force -Recurse -ErrorAction SilentlyContinue 
    $exists18 = test-path "Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker"
    if ($exists18 -eq $True) {
        "ClearbarStartAtLoginTask Unsuccessful => Registry::hklm\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ClearUpdateChecker"
    }
}
