# Terminate Process

Get-Process wavebrowser -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process SWUpdater -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

# Removal from File System

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\users\$i\Wavesor Software" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
        rm "C:\users\$i\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
        rm "C:\users\$i\appdata\local\WaveBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
        rm "C:\users\$i\appdata\local\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
        rm "C:\users\$i\downloads\Wave Browser*.exe" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    }
}

# Removal from services

Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Wave*' -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\windows\system32\tasks\Wavesor*" -Recurse -Confirm:$false -ErrorAction SilentlyContinue

# Removal from registry key

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        Remove-Item -Path Registry::$j\Software\WaveBrowser -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path Registry::$j\Software\Wavesor -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path Registry::$j\Software\WebNavigatorBrowser -Recurse -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Wavesor SWUpdater" -ErrorAction SilentlyContinue
    }
}

# Checking Removal

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
	    $result = test-path -Path "C:\users\$i\Wavesor Software"
        if ($result -eq "True") {
            "WaveBrowser wasn't removed => on C:\users\$i\Wavesor Software"
        } else { "Remediation Script Successfully Removed WaveBrowser from profile $i" }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $result = test-path -Path Registry::$i\Software\WaveBrowser
        if ($result -eq "True") {
            "WaveBrowser registry key wasn't removed => on Registry::$i\Software\WaveBrowser"
        } else { "Remediation Script Successfully Removed WaveBrowser registry HKUSER $i" }
    }
}

# Removal of uninstall key
$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
	if ($j -notlike "*_Classes*") {
		$exists = Test-Path -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser" -ErrorAction SilentlyContinue
		$exists2 = Test-Path -Path "Registry::$j\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser" -ErrorAction SilentlyContinue
		if ($exists -eq $True) {
            Remove-Item -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser" -Recurse -ErrorAction SilentlyContinue
            $exists = Test-Path -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser" -ErrorAction SilentlyContinue
            if ($exists -eq $True) {
            	"WaveBrowser Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser"
            }
        }
        if ($exists2 -eq $True) {
            Remove-Item -Path "Registry::$j\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser" -Recurse -ErrorAction SilentlyContinue
            $exists2 = Test-Path -Path "Registry::$j\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser" -ErrorAction SilentlyContinue
            if ($exists2 -eq $True) {
                "WaveBrowser Removal Unsuccessful => Registry::$j\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser"
            }
        }
    }
}
