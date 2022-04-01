# Once again, Experimental, may contain false-positives

"Spring4shell Scanner"

"`n[+] Detecting Java Version: (Java Versions 9 or greater is vulnerable)"
(Get-Command java | Select-Object -ExpandProperty Version).toString() # changed java -version due to issues with CrowdStrike

"`n[+] Enumerating Spring Framework Jar Files on the system: "
$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

$jarlist = @()
$warlist = @()
$CachedIntrospection = @()

# Search user profiles
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $result = gci "C:\users\$i" -r -fi "spring-beans-*.jar" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        foreach ($j in $result) {
        	if ($j -notlike "*OneDrive*") {
        		if ($j -like "*spring-beans*") {
                	$jarlist += $j
            	}    	
            }
        }
    }
}

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $result = gci "C:\users\$i" -r -fi "*.war" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        foreach ($j in $result) {
        	if ($j -notlike "*OneDrive*") {
        		if ($j -like "*.war") {
                	$warlist += $j
            	}    	
            }
        }
    }
}

foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        $result = gci "C:\users\$i" -r -fi "CachedIntrospectionResuLts.class" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        foreach ($j in $result) {
        	if ($j -notlike "*OneDrive*") {
        		if ($j -like "*CachedIntrospectionResuLts.class") {
                	$CachedIntrospection += $j
            	}    	
            }
        }
    }
}

# Search Program Data and IIS directory
$paths = @(
    "C:\programdata\",
    "C:\program files\",
    "C:\program files (x86)\",
    "C:\inetpub\"
)

foreach ($i in $paths) {
    $result = gci "$i" -r -fi "spring-beans-*.jar" -force -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $result) {
        if ($j -like "*spring-beans*") {
            $jarlist += $j
        }
    }
}

foreach ($i in $paths) {
    $result = gci "$i" -r -fi "*.war" -force -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $result) {
        if ($j -like "*.war") {
            $warlist += $j
        }
    }
}

foreach ($i in $paths) {
    $result = gci "$i" -r -fi "CachedIntrospectionResuLts.class" -force -ErrorAction SilentlyContinue | % { $_.FullName }
    foreach ($j in $result) {
        if ($j -like "*CachedIntrospectionResuLts.class") {
            $CachedIntrospection += $j
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

# Generate blacklist
$blacklist = New-Object System.Collections.Generic.List[System.Object]
foreach ($i in $serverblacklistPaths) {
    $blacklist += $i
}

# Generate A-Z
$apha = New-Object System.Collections.Generic.List[System.Object]
for ($x = 0; $x -lt 26; $x++)
{
    $alpha += [char](65 + $x)
}

# Generate a lit of drive letter
$drives = New-Object System.Collections.Generic.List[System.Object]
foreach ($i in 0..25) {
    foreach ($j in $alpha) {
        $drives += "{0}:\" -f ($j[$i])
    }
}

# Create a list of accessible drives
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

# Search Spring jar files in valid drives
foreach ($i in $filtereddirs) {
    $result = (Get-Item $i -ErrorAction SilentlyContinue) -is [System.IO.DirectoryInfo] 
    if ($result -eq "True") {
        $result = gci "$i" -r -fi "spring-beans-*.jar" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        $jarlist += $result
    }
}

# Search Spring war files in valid drives
foreach ($i in $filtereddirs) {
    $result = (Get-Item $i -ErrorAction SilentlyContinue) -is [System.IO.DirectoryInfo] 
    if ($result -eq "True") {
        $result = gci "$i" -r -fi "*.war" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        $warlist += $result
    }
}

foreach ($i in $filtereddirs) {
    $result = (Get-Item $i -ErrorAction SilentlyContinue) -is [System.IO.DirectoryInfo] 
    if ($result -eq "True") {
        $result = gci "$i" -r -fi "CachedIntrospectionResuLts.class" -force -ErrorAction SilentlyContinue | % { $_.FullName }
        $CachedIntrospection += $result
    }
}

"`n[+] Discovered Spring Jar Files: "
$jarlist

"`n[+] Discovered Spring War Files"
$warlist

"`n[+] Discovered Spring Class Files"
$CachedIntrospection

$jdkdir = gci "C:\Program Files\Java\jdk*" -ErrorAction SilentlyContinue | % { $_.FullName }
$isexist = test-path -Path $jdkdir
if ($isexist -eq "True") {
    "`n[+] Discovered Java Development Kit. Attempting to enumerate war file for Spring Jar files: "
    foreach ($war in $warlist) {
        "[+] Enumerating $($war): "
        & "$jdkdir\bin\jar.exe" tf "$war" | select-string -pattern ".*spring-beans-.*\.jar"
    }
}
