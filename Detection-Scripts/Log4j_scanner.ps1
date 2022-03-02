# I decided to release my lame CrowdStrike-based log4j scanner for Windows Servers.  It was very helpful for me at times.  I understand now is super late, but why not right?

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

# checks all user profiles for log4j and filters out heavy folders such as onedrive.
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $result = gci "C:\users\$i" -r -fi "log4j*.jar" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        foreach ($j in $result) {
        	if ($j -notlike "*OneDrive*") {
        		if ($j -like "*log4j*") {
                	$j
            	}    	
            }
        }
    }
}

$paths = @(
    "C:\programdata\",
    "C:\program files\",
    "C:\program files (x86)\",
    "C:\inetpub\"
)

foreach ($i in $paths) {
    $result = gci "$i" -r -fi "log4j*.jar" -force -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $result) {
        if ($j -like "*log4j*") {
            $j
        }
    }
}

$serverblacklistPaths = @(
    "\programdata",
    "\program files",
    "\program files (x86)",
    "\PerfLogs",
    "\Recovery",
    "\System Volume Information",
    "\Users",
    "\Windows",
    "\bootmgr",
    "\BOOTNXT",
    "\pagefile.sys"
)

# generate blacklist
$blacklist = New-Object System.Collections.Generic.List[System.Object]
foreach ($i in $serverblacklistPaths) {
    $blacklist += $i
}

# generate alphabets A-Z
$apha = New-Object System.Collections.Generic.List[System.Object]
for ($x = 0; $x -lt 26; $x++)
{
    $alpha += [char](65 + $x)
}

# generate list of drives
$drives = New-Object System.Collections.Generic.List[System.Object]
foreach ($i in 0..25) {
    foreach ($j in $alpha) {
        $drives += "{0}:\" -f ($j[$i])
    }
}

# filters out the blacklisted directories for each drive that exists on the system
# bug! nested foreach loop failed.. for loop for $current directory and for loop for $blacklist causes duplicate results.
# update: bug fixed 01-05-2022, boolean switching mechanism added and breaks to prevent duplication. Thanks to @dee-see for trouble-shooting the nested loops.
$filtereddirs = New-Object System.Collections.Generic.List[System.Object]
$currentdirs = New-Object System.Collections.Generic.List[System.Object]
foreach  ($i in $drives) {
    $result = test-path -Path $i
    if ($result -eq "True") {
        $currentdirs = gci $i -force -ErrorAction SilentlyContinue | % { $_.FullName }
        foreach ($j in $currentdirs) {
            $isBlacklisted  = $false
            foreach ($k in $blacklist) {
                if ($j -like "*$k") {
                    $isBlacklisted  = $true
                    break
                }
            }
            if (-not $isBlacklisted ) {
                $filtereddirs += $j
            }
        }
    }
}

# Check if only directories and then run a scan on each directory for log4j
foreach ($i in $filtereddirs) {
    $result = (Get-Item $i -ErrorAction SilentlyContinue) -is [System.IO.DirectoryInfo] 
    if ($result -eq "True") {
        $result = gci "$i" -r -fi "log4j*.jar" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        $result
    }
}
