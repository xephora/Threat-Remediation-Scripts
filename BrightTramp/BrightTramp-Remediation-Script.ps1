Get-Process BrightuUtil -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process BrightTRAMPUtil -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\users\$i\Downloads\InstaRipper*.exe"
        $exists = test-path "C:\Users\$i\appdata\local\BrightTRAMPlfoUtil"
        $exists2 = test-path "C:\Users\$i\appdata\local\BrightTRAMPkysUtil"
        $exists3 = test-path "C:\Users\$i\appdata\local\BrightTRAMP"
        
        if ($exists -eq $True) {
            "Discovered BrightTramp Adware => C:\Users\$i\appdata\local\BrightTRAMPlfoUtil"
            rm "C:\Users\$i\appdata\local\BrightTRAMPlfoUtil" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\Users\$i\appdata\local\BrightTRAMPlfoUtil"
            if ($exists -eq $True) {
                "BrightTramp Adware Removal Unsuccessful => C:\Users\$i\appdata\local\BrightTRAMPlfoUtil" 
            }
        }
        if ($exists2 -eq $True) {
            "Discovered BrightTramp Adware => C:\Users\$i\appdata\local\BrightTRAMPkysUtil"
            rm "C:\Users\$i\appdata\local\BrightTRAMPkysUtil" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\Users\$i\appdata\local\BrightTRAMPkysUtil"
            if ($exists2 -eq $True) {
                "BrightTramp Adware Removal Unsuccessful => C:\Users\$i\appdata\local\BrightTRAMPkysUtil" 
            }
        }
        if ($exists3 -eq $True) {
            "Discovered BrightTramp Adware => C:\Users\$i\appdata\local\BrightTRAMP"
            rm "C:\Users\$i\appdata\local\BrightTRAMP" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists3 = test-path "C:\Users\$i\appdata\local\BrightTRAMP"
            if ($exists3 -eq $True) {
                "BrightTramp Adware Removal Unsuccessful => C:\Users\$i\appdata\local\BrightTRAMP" 
            }
        }
    }
}
