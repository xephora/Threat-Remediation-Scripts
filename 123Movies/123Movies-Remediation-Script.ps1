Get-Process 123movies -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process Update -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2


$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    $installers = @(gci C:\users\$i -r -fi "123Movies*.exe" | % {$_.FullName})
    foreach ($install in $installers) {
        if (test-path -Path $install) {
            rm "$install"
            $installers = @(gci C:\users\$i -r -fi "123Movies*.exe" | % {$_.FullName})
            if (test-path -Path $install) {
                "Failed to remove 123Movies -> $install"
            }
        }
    }
    if (test-path -Path "C:\Users\$i\appdata\local\123movies") {
        rm "C:\Users\$i\appdata\local\123movies" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\local\123movies") {
            "Failed to remove 123Movies -> C:\Users\$i\appdata\local\123movies"
        }
    }
    if (test-path -Path "C:\Users\$i\appdata\roaming\123movies") {
        rm "C:\Users\$i\appdata\roaming\123movies" -Force -Recurse -ErrorAction SilentlyContinue
        if (test-path -Path "C:\Users\$i\appdata\roaming\123movies") {
            "Failed to remove 123Movies -> C:\Users\$i\appdata\roaming\123movies"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        $regkeys = @(gci "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Uninstall\123movies")
        foreach ($key in $regkeys) {
            if (test-path -Path $key) {
                Remove-Item -Path "Registry::$key" -Recurse
                if (test-path -Path $key) {
                    "Failed to remove 123Movies -> $key"
                }
            }
        }
        $keypath = "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run"
        $keyexists = (Get-Item $keypath).Property -contains "com.squirrel.123movies.123movies"
        if ($keyexists -eq $True) {
            Remove-ItemProperty -Path "Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run" -Name "com.squirrel.123movies.123movies" -ErrorAction SilentlyContinue
            $keyexists = (Get-Item $keypath).Property -contains "com.squirrel.123movies.123movies"
            if ($keyexists -eq $True) {
                "Failed to remove 123Movies => Registry::$i\Software\Microsoft\Windows\CurrentVersion\Run.com.squirrel.123movies.123movies"
            }
        }
    }
}
