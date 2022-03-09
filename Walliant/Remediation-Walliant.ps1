Function intro {
    <#
            .SYNOPSIS
                Remediation script for Walliant adware.
    
            .DESCRIPTION
                The script will stop browser session, remove files, registry keys associated with WebBrowser.
            .EXAMPLE

                Description
                -----------
                Kills the process
                Removes registry keys associated with Wave Browser Hijacking Software.
                Removes files associated with Wave Browser Hijacking Software.
        #>
}

# Removal
$users = Get-ChildItem c:\users | select-object name -expandproperty name
$regkeys = get-item -path "registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

get-process -name walliant -ErrorAction SilentlyContinue | stop-process
sleep 2

foreach ($user in $users) {
    if ($user -ne "public") {
        rm "C:\Users\$user\appdata\local\walliant" -force -recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$user\AppData\Local\Programs\walliant" -force -recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\walliant" -force -recurse -ErrorAction SilentlyContinue
    }
}

foreach ($reg in $regkeys) {
    if ($reg -notlike "*_Classes") {
        remove-ItemProperty -path "Registry::$reg\Software\Microsoft\Windows\CurrentVersion\Run" -name "walliant" -ErrorAction SilentlyContinue
        remove-item -path "Registry::$reg\software\microsoft\windows\CurrentVersion\Uninstall\{E72E2194-F430-4F4A-A262-1C8FF081B3A5}_is1" -recurse -ErrorAction SilentlyContinue
    }
}

remove-Item -Path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\walliant_RASAPI32" -recurse -ErrorAction SilentlyContinue
remove-item -path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\walliant_RASMANCS" -recurse -ErrorAction SilentlyContinue

# Check
foreach ($user in $users) {
    if ($user -ne "public") {
        $checkwall1 = test-path "C:\Users\$user\appdata\local\walliant"
        if ($checkwall1 -eq "True") {
            "This script failed to remove C:\Users\$user\appdata\local\walliant"
        }

        $checkwall2 = test-path "C:\Users\$user\AppData\Local\Programs\Walliant"
        if ($checkwall2 -eq "True"){
            "This script failed to remove C:\Users\$user\AppData\Local\Programs\Walliant"
        }

        $checkwall3 = test-path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Walliant"
        if ($checkwall3 -eq "True"){
            "This script failed to remove C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Walliant"
        }
    }
}

foreach ($reg in $regkeys) {
    if ($reg -notlike "*_Classes") {
        $wallreg2 = test-path -path "Registry::$reg\software\microsoft\windows\CurrentVersion\Uninstall\{E72E2194-F430-4F4A-A262-1C8FF081B3A5}_is1" -ErrorAction SilentlyContinue
        if ($wallreg2) {"This script failed to remove Registry::$reg\software\microsoft\windows\CurrentVersion\Uninstall\{E72E2194-F430-4F4A-A262-1C8FF081B3A5}_is1"} else {continue}
    }
}

$wallreg3 = test-path -path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\walliant_RASAPI32" -ErrorAction SilentlyContinue
if ($wallreg3) {"This script failed to remove Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\walliant_RASAPI32"} else {continue}

$wallreg4 = test-path -path "Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\walliant_RASMANCS" -ErrorAction SilentlyContinue
if ($wallreg4) {"This script failed to remove Registry::hklm\Software\Wow6432Node\Microsoft\Tracing\walliant_RASMANCS"} else {continue}
