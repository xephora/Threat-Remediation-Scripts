$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

# Removal from file system and scheduled task

Get-Process litebrowser -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

rm "C:\windows\system32\tasks\Launch LiteBrowser" -ErrorAction SilentlyContinue
rm "C:\windows\system32\tasks\LiteBrowser Updater" -ErrorAction SilentlyContinue

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\Users\$i\AppData\Roaming\LiteBrowser.org" -Force -Recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$i\appdata\local\LiteBrowser" -Force -Recurse -ErrorAction SilentlyContinue
        rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\LiteBrowser.lnk" -ErrorAction SilentlyContinue
    }
}

# removal from registry and reg service

Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Launch LiteBrowser' -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\LiteBrowser Updater' -Recurse -ErrorAction SilentlyContinue

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        Remove-Item -Path "Registry::$i\Software\LiteBrowser" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "Registry::$i\Software\LiteBrowser.org" -Recurse -ErrorAction SilentlyContinue
    }
}

# check removal

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
	    $result = test-path -Path "C:\Users\$i\AppData\Roaming\LiteBrowser.org"
        if ($result -eq "True") {
            "LiteBrowser wasn't removed from C:\Users\$i\AppData\Roaming\LiteBrowser.org"
        } else { continue }
    }
}

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
	    $result = test-path -Path "C:\Users\$i\appdata\local\LiteBrowser"
        if ($result -eq "True") {
            "LiteBrowser wasn't removed from C:\Users\$i\appdata\local\LiteBrowser"
        } else { continue }
    }
}

$result = test-path -Path "C:\windows\system32\tasks\Launch LiteBrowser"
if ($result -eq "True") {
    "LiteBrowser wasn't removed from C:\windows\system32\tasks\Launch LiteBrowser"
} else { continue }

$result = test-path -Path "C:\windows\system32\tasks\LiteBrowser Updater"
if ($result -eq "True") {
    "LiteBrowser wasn't removed from C:\windows\system32\tasks\LiteBrowser Updater"
} else { continue }

$result = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Launch LiteBrowser"
if ($result -eq "True") {
    "LiteBrowser wasn't removed from Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Launch LiteBrowser"
} else { continue }

$result = test-path -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\LiteBrowser Updater"
if ($result -eq "True") {
    "LiteBrowser wasn't removed from Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\LiteBrowser Updater"
} else { continue }

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $result = test-path -Path "Registry::$i\Software\LiteBrowser"
        if ($result -eq "True") {
            "LiteBrowser wasn't removed from Registry::$i\Software\LiteBrowser"
        } else { continue }
    }
}

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $result = test-path -Path "Registry::$j\Software\LiteBrowser.org"
        if ($result -eq "True") {
            "LiteBrowser wasn't removed from Registry::$j\Software\LiteBrowser.org"
        } else { continue }
    }
}
