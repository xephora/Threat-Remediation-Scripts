# I created this script to automate the removal of this malware.  This was created two weeks after the campaign started.  The reason why i didn't release it to the public was because I was still experimenting and didn't want to cause any potential issues. However, I am archiving this script publically and in the event I come across this type of malware again, any one can use my work to help speed up the process of remediation.

Function RemediateSystem {
    # Remediation of disk images
    Dismount-DiskImage -DevicePath \\.\CDROM0 -ErrorAction SilentlyContinue
    Dismount-DiskImage -DevicePath \\.\CDROM1 -ErrorAction SilentlyContinue
    Dismount-DiskImage -DevicePath \\.\CDROM2 -ErrorAction SilentlyContinue
    Dismount-DiskImage -DevicePath \\.\CDROM3 -ErrorAction SilentlyContinue

    $user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
    $getFiles = New-Object System.Collections.Generic.List[System.Object]

    # Remediation of ISOs
    foreach ($i in $user_list) {
        if ($i -notlike "*Public*") {
            $getFiles = gci C:\users\$i\Downloads -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }
            foreach ($j in $getFiles) {
                Get-FileHash "$j" -Algorithm SHA256 -ErrorAction SilentlyContinue
                rm "C:\users\$i\Downloads\*.iso" -ErrorAction SilentlyContinue
            }
        }   
    }

    # Remediation of Extension
    foreach ($i in $user_list) {
        if ($i -notlike "*Public*") {
            $result = test-path -Path "C:\users\$i\appdata\local\chrome" -ErrorAction SilentlyContinue
            if ($result) {
                "Discovered and removing C:\users\$i\appdata\local\chrome"
                rm -force "C:\users\$i\appdata\local\chrome" -recurse -ErrorAction SilentlyContinue
            } else {
                continue
            }
        }
    }

    ### Remediation of Tasks

    $ChromeLoaderTaskName = @(
        "Loader",
        "Monitor",
        "Checker",
        "Conf",
        "Task",
        "Updater"
    )

    foreach ($i in $ChromeLoaderTaskName) {
        Unregister-ScheduledTask -TaskName "Chrome$i" -Confirm:$false -EA SilentlyContinue 
    }

    ### Remediation of Registry Keys
    $result = test-path -Path "C:\windows\system32\tasks\ChromeLoader"
    if ($result -eq "True") {
        rm "C:\windows\system32\tasks\ChromeLoader"
        Remove-Item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeLoader" -Recurse
        $result = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeLoader"
        $result = $result.ToString()
        $taskUID = $result.Split(" ")[11].replace("NT\CurrentVersion\Schedule\TaskCache\Tasks\","").replace(";", "")
        $regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskUID"
        "Discovered task UID $regKeyPath"
        Remove-Item -Path $regKeyPath
    } else {
        "C:\windows\system32\tasks\ChromeLoader Not Detected"
        $checkRemove = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeLoader"
        if ($checkRemove) {
            
        } else {
            "RegKey HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeLoader Removed or Does not Exist"
        }
    }
    
    $result = test-path -Path "C:\windows\system32\tasks\ChromeTask"
    if ($result -eq "True") {
        rm "C:\windows\system32\tasks\ChromeTask"
        Remove-Item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeTask" -Recurse
        $result = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeTask"
        $result = $result.ToString()
        $taskUID = $result.Split(" ")[11].replace("NT\CurrentVersion\Schedule\TaskCache\Tasks\","").replace(";", "")
        $regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskUID"
        "Discovered task UID $regKeyPath"
        Remove-Item -Path $regKeyPath
    } else {
        "C:\windows\system32\tasks\ChromeTask Not Detected"
        $checkRemove = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeTask"
        if ($checkRemove) {
            
        } else {
            "RegKey HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeTask Removed or Does not Exist"
        }
    }
    
    $result = test-path -Path "C:\windows\system32\tasks\ChromeConf"
    if ($result -eq "True") {
        rm "C:\windows\system32\tasks\ChromeConf"
        Remove-Item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeConf" -Recurse
        $result = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeConf"
        $result = $result.ToString()
        $taskUID = $result.Split(" ")[11].replace("NT\CurrentVersion\Schedule\TaskCache\Tasks\","").replace(";", "")
        $regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskUID"
        "Discovered task UID $regKeyPath"
        Remove-Item -Path $regKeyPath
    } else {
        "C:\windows\system32\tasks\ChromeConf Not Detected"
        $checkRemove = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeConf"
        if ($checkRemove) {
            
        } else {
            "RegKey HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeConf Removed or Does not Exist"
        }
    }

    $result = test-path -Path "C:\windows\system32\tasks\ChromeMonitor"
    if ($result -eq "True") {
        rm "C:\windows\system32\tasks\ChromeMonitor"
        Remove-Item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeMonitor" -Recurse
        $result = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeMonitor"
        $result = $result.ToString()
        $taskUID = $result.Split(" ")[11].replace("NT\CurrentVersion\Schedule\TaskCache\Tasks\","").replace(";", "")
        $regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskUID"
        "Discovered task UID $regKeyPath"
        Remove-Item -Path $regKeyPath
    } else {
        "C:\windows\system32\tasks\ChromeMonitor Not Detected"
        $checkRemove = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeMonitor"
        if ($checkRemove) {
            
        } else {
            "RegKey HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeMonitor Removed or Does not Exist"
        }
    }

    $result = test-path -Path "C:\windows\system32\tasks\ChromeChecker"
    if ($result -eq "True") {
        rm "C:\windows\system32\tasks\ChromeChecker"
        Remove-Item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeChecker" -Recurse
        $result = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeChecker"
        $result = $result.ToString()
        $taskUID = $result.Split(" ")[11].replace("NT\CurrentVersion\Schedule\TaskCache\Tasks\","").replace(";", "")
        $regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskUID"
        "Discovered task UID $regKeyPath"
        Remove-Item -Path $regKeyPath
    } else {
        "C:\windows\system32\tasks\ChromeChecker Not Detected"
        $checkRemove = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeChecker"
        if ($checkRemove) {
            
        } else {
            "RegKey HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeChecker Removed or Does not Exist"
        }
    }

    ### Checks
    
    $result = test-path -Path "C:\windows\system32\tasks\ChromeUpdater"
    if ($result -eq "True") {
        rm "C:\windows\system32\tasks\ChromeUpdater"
        Remove-Item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeUpdater" -Recurse
        $result = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeUpdater"
        $result = $result.ToString()
        $taskUID = $result.Split(" ")[11].replace("NT\CurrentVersion\Schedule\TaskCache\Tasks\","").replace(";", "")
        $regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskUID"
        "Discovered task UID $regKeyPath"
        Remove-Item -Path $regKeyPath
    } else {
        "C:\windows\system32\tasks\ChromeUpdater Not Detected"
        $checkRemove = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeUpdater"
        if ($checkRemove) {
            
        } else {
            "RegKey HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeUpdater Removed or Does not Exist"
        }
    }
}

Function KillChrome {
    Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    sleep 2

    
}

Function CheckSystem {
    $user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
    foreach ($i in $user_list) {
        if ($i -notlike "*Public*") {
            $result = test-path -Path "C:\users\$i\appdata\local\chrome"
            if ($result) {
                "Failed to remove => C:\users\$i\appdata\local\chrome"
            } else {
                "Extension Successfully Removed from profile $i or Extension does not exist on system"
            }
        }
    }

    foreach ($i in $user_list) {
        if ($i -notlike "*Public*") {
            $getFiles = gci C:\users\$i\Downloads -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }
            foreach ($i in $getFiles) {
            if ($i) {
                "ISO still exists => $i. ISO Is locked, please dismount disk image."
                }
            }
        }
    }
}

# Uncomment KillChrome if the malicious extension is in use.
# KillChrome
RemediateSystem
CheckSystem
