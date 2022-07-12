Get-Process GameCenter -ErrorAction SilentlyContinue | stop-Process -force

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path -path "C:\Users\$i\appdata\local\GameCenter"
        if ($exists -eq $True) {
            rm "C:\Users\$i\appdata\local\GameCenter" -Force -Recurse -ErrorAction SilentlyContinue
            $exists = test-path -path "C:\Users\$i\appdata\local\GameCenter"
            if ($exists -eq $True) {
                "Failed to remove GameCenter => C:\Users\$i\appdata\local\GameCenter"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $keyexists = test-path -path "Registry::$i\Software\GameCenter"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\GameCenter" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\GameCenter"
            if ($keyexists -eq $True) {
                "failed to remove GameCenter => Registry::$i\Software\GameCenter"
            }
        }
        $keyexists = test-path -path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\GameCenter"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\GameCenter" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\GameCenter"
            if ($keyexists -eq $True) {
                "failed to remove GameCenter => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\GameCenter"
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "GameCenter"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "GameCenter" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "GameCenter"
            if ($keyexists -eq $True) {
                "failed to remove GameCenter => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.GameCenter"
            }
        }
    }
}
