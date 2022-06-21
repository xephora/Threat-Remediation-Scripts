Get-Process PCAppStore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\Users\$i\PCAppStore"
        $exists2 = test-path "C:\Users\$i\AppData\Roaming\PCAppStore"
        if ($exists -eq $True) {
            rm "C:\Users\$i\PCAppStore" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$i\PCAppStore"
            if ($exists -eq $True) {
                "PCAppStore Removal Unsuccessful => C:\Users\$i\PCAppStore" 
            }
        }
        if ($exists2 -eq $True) {
            rm "C:\Users\$i\AppData\Roaming\PCAppStore" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\Users\$i\AppData\Roaming\PCAppStore"
            if ($exists2 -eq $True) {
                "PCAppStore Removal Unsuccessful => C:\Users\$i\AppData\Roaming\PCAppStore"
            }
        }
        $exists3 = test-path -path "C:\Users\$i\AppData\Local\Temp\z.exe"
        if ($exists3 -eq $True) {
            rm "C:\Users\$i\AppData\Local\Temp\z.exe"
            # Adware PCAppStore attempts to add an exclusion to Windows Defender for 'z.exe' in the 'temp' directory of the affected user profile.  If the file in question exists, then remove the file and the exclusion.
            Remove-MpPreference -ExclusionProcess "C:\Users\$i\AppData\Local\Temp\z.exe" -ErrorAction SilentlyContinue
            $exists3 = test-path -path "C:\Users\$i\AppData\Local\Temp\z.exe"
            if ($exists3 -eq $True) {
                "PCAppStore Removal Unsuccessful => C:\Users\$i\AppData\Local\Temp\z.exe"
            }
        }
        $exists4 = test-path -Path "C:\Users\$i\downloads\Zoom-Setup-PCAppStore*.exe"
        if ($exists4 -eq $True) {
            rm "C:\Users\$i\Zoom-Setup-PCAppStore*.exe" -ErrorAction SilentlyContinue
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        $exists = test-path -path "Registry::$j\SOFTWARE\PCAppStore"
        if ($exists -eq $True) {
            Remove-Item -Path "Registry::$j\SOFTWARE\PCAppStore" -Recurse -ErrorAction SilentlyContinue
            $exists = test-path -path "Registry::$j\SOFTWARE\PCAppStore"
            if ($exists -eq $True) {
                "PCAppStore Removal Unsuccessful => Registry::$j\SOFTWARE\PCAppStore"
            }
        }
    }
}
