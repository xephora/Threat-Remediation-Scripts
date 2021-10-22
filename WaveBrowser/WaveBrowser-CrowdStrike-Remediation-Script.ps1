# Removal

Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process iexplore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process SWUpdater -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

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

$tasks = Get-ScheduledTask -TaskName *Wave* | Select-Object -ExpandProperty TaskName
foreach ($i in $tasks) {
	Unregister-ScheduledTask -TaskName $i -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        Remove-Item -Path Registry::$j\Software\WaveBrowser -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path Registry::$j\Software\Wavesor -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path Registry::$j\Software\WebNavigatorBrowser -Recurse -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Wavesor SWUpdater" -ErrorAction SilentlyContinue
    }
}

# Quick Check

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
	    $result = test-path -Path "C:\users\$i\Wavesor Software"
        if ($result -eq "True") {
            "WaveBrowser wasn't removed => on C:\users\$i\Wavesor Software"
        }
    }
}


$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $result = test-path -Path Registry::$i\Software\WaveBrowser
        if ($result -eq "True") {
            "WaveBrowser registry key wasn't removed => on Registry::$i\Software\WaveBrowser"
        }
    }
}
