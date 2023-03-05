Get-Process AppRun -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if (test-path -Path "C:\Users\$i\appdata\roaming\AppRun") {
        rm "C:\Users\$i\appdata\roaming\AppRun" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\roaming\AppRun") {
            "Failed to remove AppRun -> C:\Users\$i\appdata\roaming\AppRun"
        }
    }
}

Remove-Item -Path "C:\windows\system32\tasks\Update_Zoremov" -ErrorAction SilentlyContinue
Remove-Item -Path 'Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Update_Zoremov' -Recurse -ErrorAction SilentlyContinue

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $keyexists = test-path -path "Registry::$i\Software\Apprun"
        if ($keyexists -eq $True) {
            Remove-Item -Path "Registry::$i\Software\Apprun" -Recurse -ErrorAction SilentlyContinue
            $keyexists = test-path -path "Registry::$i\Software\Apprun"
            if ($keyexists -eq $True) {
                "Failed to remove AppRun => Registry::$i\Software\Apprun"
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "AppRun"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AppRun" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "AppRun"
            if ($keyexists -eq $True) {
                "Failed to remove AppRun => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.AppRun"
            }
        }
    }
}
