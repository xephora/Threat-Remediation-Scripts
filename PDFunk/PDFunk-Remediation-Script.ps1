Get-Process PDFunk -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2
$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $exists = test-path "C:\users\$i\appdata\local\PDFunk"
        $exists2 = test-path "C:\users\$i\appdata\roaming\PDFunk"
        $exists3 = test-path "C:\users\$i\appdata\local\pdfunk-updater"
        $exists4 = test-path "C:\Users\$i\AppData\Local\Programs\PDFunk"
        $exists5 = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PDFunk.lnk"        
        $exists6 = test-path "C:\Users\$i\Downloads\PdfConverters*"  
        if ($exists -eq $True) {
            rm "C:\users\$i\appdata\local\PDFunk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists = test-path "C:\users\$i\appdata\local\PDFunk"
            if ($exists -eq $True) {
                "PDFunk Removal Unsuccessful => C:\users\$i\appdata\local\PDFunk" 
            }
        } 
        if ($exists2 -eq $True) {
            rm "C:\users\$i\appdata\roaming\PDFunk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists2 = test-path "C:\users\$i\appdata\roaming\PDFunk"
            if ($exists2 -eq $True) {
                "PDFunk Removal Unsuccessful => C:\users\$i\appdata\roaming\PDFunk"
            }
        }
        if ($exists3 -eq $True) {
            rm "C:\users\$i\appdata\local\pdfunk-updater" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists3 = test-path "C:\users\$i\appdata\local\pdfunk-updater"
            if ($exists3 -eq $True) {
                "PDFunk Removal Unsuccessful => C:\users\$i\appdata\local\pdfunk-updater"
            }
        }
        if ($exists4 -eq $True) {
            rm "C:\Users\$i\AppData\Local\Programs\PDFunk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists4 = test-path "C:\Users\$i\AppData\Local\Programs\PDFunk"
            if ($exists4 -eq $True) {
                "PDFunk Removal Unsuccessful => C:\Users\$i\AppData\Local\Programs\PDFunk"
            }
        }
        if ($exists5 -eq $True) {
            rm "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PDFunk.lnk" -Force -Recurse -ErrorAction SilentlyContinue 
            $exists5 = test-path "C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PDFunk.lnk"
            if ($exists5 -eq $True) {
                "PDFunk Removal Unsuccessful => C:\Users\$i\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\PDFunk.lnk"
             }
        }
        if ($exists6 -eq $True) {
            rm "C:\Users\$i\Downloads\PdfConverters*"
            $exists6 = $exists6 = test-path "C:\Users\$i\Downloads\PdfConverters*"
            if ($exists6 -eq $True) {
                "PdfConverters Removal Unsuccessful => C:\Users\$i\Downloads"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
    	$exists7 = test-path -path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\98da245b-e554-5838-b247-454aefcb1803"
        if ($exists7 -eq $True) {
            rm "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\98da245b-e554-5838-b247-454aefcb1803" -ErrorAction SilentlyContinue
    	    $exists7 = test-path -path "Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\98da245b-e554-5838-b247-454aefcb1803"
            if ($exists7 -eq $True) {
                "PDFunk Removal Unsuccessful => Registry::$j\Software\Microsoft\Windows\CurrentVersion\Uninstall\98da245b-e554-5838-b247-454aefcb1803"
            }
        }
    }
}
