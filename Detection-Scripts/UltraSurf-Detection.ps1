Function intro {
    <#
            .SYNOPSIS
                Detection script for UltraSurf Anonymizer
    
            .DESCRIPTION
                The script will passively discover and not remove. (Testing phase for now to confirm accuracy). Once testing phase is complete then I will convert to remediation.
            .EXAMPLE
                Simply run the script and it will enumerate UltraSurf binaries.
    
                Description
                -----------
                Loops through each profile
                Enumerates desktop, documents and downloads for Ultrasurf
                Regex have been added to discover unique binaries
        #>
    }

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
$getFiles = New-Object System.Collections.Generic.List[System.Object]
foreach ($i in $user_list) {
  if ($i -notlike "*Public*") {
    $getFiles = gci C:\users\$i\Downloads -r -force -fi "u.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Downloads -r -force -fi "usf.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Downloads -r -force -ErrorAction SilentlyContinue | where {$_.Name -match "u[0-9 \(\)]+\.exe"} | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Desktop -r -force -fi "u.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Desktop -r -force -fi "usf.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Desktop -r -force -ErrorAction SilentlyContinue | where {$_.Name -match "u[0-9 \(\)]+\.exe"} | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Documents -r -force -fi "u.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Documents -r -force -fi "usf.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
    $getFiles = gci C:\users\$i\Documents -r -force -ErrorAction SilentlyContinue | where {$_.Name -match "u[0-9 \(\)]+\.exe"} | % { $_.FullName }
    foreach ($j in $getFiles) {
      "found: $j"
		}
	}   
}
