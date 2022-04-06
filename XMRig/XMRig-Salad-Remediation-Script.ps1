$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
$regkeys = get-item -path "registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

# Kill Process

get-process -name Salad -ErrorAction SilentlyContinue | Stop-process -Force
sleep 2

# Removal from file system

rm "C:\Program Files\Salad" -force -recurse -ErrorAction SilentlyContinue

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\Users\$i\AppData\Roaming\Salad" -Force -Recurse -ErrorAction SilentlyContinue
        rm "C:\users\$i\Downloads\Salad*.exe" -ErrorAction SilentlyContinue
        rm "C:\Users\$i\appdata\local\salad-updater" -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# Removal from registry

Remove-Item -path "Registry::hklm\Software\7a0ebc42-7f71-5caa-9738-b7dda7589c77" -recurse -ErrorAction SilentlyContinue

foreach ($reg in $regkeys) {
    if ($reg -notlike "*_Classes") {
        Remove-ItemProperty -path "Registry::$reg\Software\Microsoft\Windows\CurrentVersion\Run" -name "Salad" -ErrorAction SilentlyContinue
    }
}

# Check removal

$check = Test-Path -path "C:\Program Files\Salad" -ErrorAction SilentlyContinue
if ($check) {
    "Failed to remove C:\Program Files\Salad"
}
else {
    continue
}

foreach ($user in $user_list) {
    if ($user -ne "Public") {
        $check1 = Test-Path "C:\Users\$user\AppData\Roaming\Salad"
        if ($check1 -eq "True") {
            "This script failed to remove C:\Users\$user\AppData\Roaming\Salad"
        }
        $check2 = Test-Path "C:\Users\$user\appdata\local\salad-updater"
        if ($check2 -eq "True") {
            "This script failed to remove C:\Users\$user\appdata\local\salad-updater"
        }
    }
}
