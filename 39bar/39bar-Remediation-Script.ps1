Get-Process 39barsvc -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process 39medint -ErrorAction SilentlyContinue | Stop-Process -Force
sleep 2

if (test-path "C:\Program Files (x86)\MapsGalaxy_39") {
    rm "C:\Program Files (x86)\MapsGalaxy_39" -force -recurse -ErrorAction SilentlyContinue
    if (test-path "C:\Program Files (x86)\MapsGalaxy_39") {
        "Failed to remove 39bar -> C:\Program Files (x86)\MapsGalaxy_39"
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($i in $sid_list) {
    if ($i -notlike "*_Classes*") {
        if (test-path "Registry::$i\Software\MapsGalaxy_39") {
            Remove-Item -Path "Registry::$i\Software\MapsGalaxy_39" -Recurse -ErrorAction SilentlyContinue
            if (test-path "Registry::$i\Software\MapsGalaxy_39") {
                "Failed to remove 39bar -> Registry::$i\Software\MapsGalaxy_39"
            }
        }
    }
}
