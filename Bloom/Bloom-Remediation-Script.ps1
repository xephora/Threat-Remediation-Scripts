$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

Get-Process Bloom -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\Users\$i\appdata\local\Bloom" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
        rm "C:\Users\$i\appdata\roaming\Bloom" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    }
}

foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        Remove-ItemProperty -Path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Bloom" -ErrorAction SilentlyContinue
    }
}

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
	    $result = test-path -Path "C:\Users\$i\appdata\local\Bloom"
        if ($result -eq "True") {
            "Bloom wasn't removed => on C:\Users\$i\appdata\local\Bloom"
        }
	    $result = test-path -Path "C:\Users\$i\appdata\roaming\Bloom"
	if ($result -eq "True") {
            "Bloom wasn't removed => on C:\Users\$i\appdata\roaming\Bloom"
        }
    }
}
