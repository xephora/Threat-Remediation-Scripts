# Kill processes

get-process -name 39barsvc -ErrorAction SilentlyContinue | Stop-process -Force
get-process -name 39medint -ErrorAction SilentlyContinue | Stop-process -Force
sleep 2

# Removal from file system

rm "C:\Program Files (x86)\MapsGalaxy_39" -force -recurse -ErrorAction SilentlyContinue

# Removal from registry

$regkeys = get-item -path "registry::hku\*" -ErrorAction SilentlyContinue | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($reg in $regkeys) {
    if ($reg -notlike "*_Classes") {
        remove-item -path "Registry::$reg\software\MapsGalaxy_39" -recurse -ErrorAction SilentlyContinue
    }
}

# Check removal

$check = Test-Path -path "C:\Program Files (x86)\MapsGalaxy_39" -ErrorAction SilentlyContinue
if ($check) {
    "Failed to remove C:\Program Files (x86)\MapsGalaxy_39"
}
else {
    continue
}

foreach ($reg in $regkeys) {
    if ($reg -notlike "*_Classes") {
        $check3 = Test-Path -path "Registry::$reg\Software\MapsGalaxy_39" -ErrorAction SilentlyContinue
        if ($check3 -eq "True") {
            "This script failed to remove Registry::$reg\Software\MapsGalaxy_39"
        }
        else {
            continue
        }
    }
}
