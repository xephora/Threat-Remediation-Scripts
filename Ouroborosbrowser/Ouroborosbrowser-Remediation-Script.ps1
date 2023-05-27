Get-Process Ouroborosbrowser -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $files=gci C:\users\$i -r -fi "*Ouroborosbrowser*exe" | % { $_.FullName }
        foreach ($file in $files) {
            $check=test-path $file
            if ($check) {
                rm $file -ErrorAction SilentlyContinue
                    $check=test-path $file
                    if ($check) {
                        "Failed to remove ouroborosbrowser -> $file"
                    }
            }
        }
        $check=test-path "C:\Users\$i\appdata\local\ouroborosbrowser-updater"
        if ($check) {
            rm "C:\Users\$i\appdata\local\ouroborosbrowser-updater" -Recurse -ErrorAction SilentlyContinue
            $check=test-path "C:\Users\$i\appdata\local\ouroborosbrowser-updater"
            if ($check) {
                "Failed to remove ouroborosbrowser -> C:\Users\$i\appdata\local\ouroborosbrowser-updater"
            }
        }
        $check=test-path "C:\Users\$i\appdata\roaming\ouroborosbrowser"
        if ($check) {
            rm "C:\Users\$i\appdata\roaming\ouroborosbrowser" -Recurse -ErrorAction SilentlyContinue
            $check=test-path "C:\Users\$i\appdata\local\ouroborosbrowser-updater"
            if ($check) {
                "Failed to remove ouroborosbrowser -> C:\Users\$i\appdata\roaming\ouroborosbrowser"
            }
        }
        $check=test-path "C:\users\$i\AppData\Local\programs\ouroborosbrowser"
        if ($check) {
            rm "C:\users\$i\AppData\Local\programs\ouroborosbrowser" -Recurse -ErrorAction SilentlyContinue
            $check=test-path "C:\users\$i\AppData\Local\programs\ouroborosbrowser"
            if ($check) {
                "Failed to remove ouroborosbrowser -> C:\users\$i\AppData\Local\programs\ouroborosbrowser"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "Ouroborosbrowser"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Ouroborosbrowser" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "Ouroborosbrowser"
            if ($keyexists -eq $True) {
                "Failed to remove Ouroborosbrowser => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.Ouroborosbrowser"
            }
        }
    }
}
