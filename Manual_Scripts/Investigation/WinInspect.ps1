# investigate the following account below.  Please replace username with the target account.
$username = "<USERNAME>"

# File System - Startups
"=> Checking Startup Locations"
"C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
gci "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
gci "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# File System
"`n`n => Checking Root Dir"
"C:\"
gci C:\ -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n => Checking ProgramData"
"C:\ProgramData"
gci "C:\ProgramData" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# Antivirus Logs (If you do not use Symantec as an Antivirus Platform, you may want to change/remove line 22-29)
"`n`n => Checking Symantec Local Antivirus Logs"
"C:\ProgramData\symantec\Symantec Endpoint Protection\currentversion\Data\Logs\av"
$result = test-path -Path "C:\ProgramData\symantec\Symantec Endpoint Protection\currentversion\Data\Logs\av"
if ($result -eq "True") {
	gci "C:\ProgramData\symantec\Symantec Endpoint Protection\currentversion\Data\Logs\av" -force -ErrorAction SilentlyContinue | % { $_.FullName, "Size: $($_.length)"}
} else {
    "Symantec Endpoint doesn't seem to be on this system.."
}

# User profile
"`n`n => Checking User Profile"
"C:\Users\$username\"
gci "C:\Users\$username\" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n => downloaded executables, msi packages and zip, rar, 7z compressed folders"
"C:\Users\$username\Downloads\"
gci C:\users\$username\Downloads -r -force -fi "*.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.msi" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.rar" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.7z" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.zip" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }

"C:\Users\$username\Desktop\"
gci C:\users\$username\Desktop -r -force -fi "*.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.msi" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.rar" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.7z" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.zip" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }

"C:\Users\$username\Documents\"
gci C:\users\$username\Documents -r -force -fi "*.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Documents -r -force -fi "*.msi" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Documents -r -force -fi "*.rar" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Documents -r -force -fi "*.7z" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Documents -r -force -fi "*.zip" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Documents -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }

# User profile application folders
"`n`n => Checking User's local application data"
"C:\Users\$username\appdata\local"
gci "C:\Users\$username\appdata\local" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n => Checking User's roaming application data"
"C:\Users\$username\appdata\roaming"
gci "C:\Users\$username\appdata\roaming" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# FileSystem Scheduled Tasks
"`n`n => Checking Scheduled Tasks"
"C:\windows\system32\tasks\"
gci "C:\windows\system32\tasks\" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# System Registry Scheduled tasks
"`n`n => Checking System Registries - Scheduled Tasks"
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\*' -ErrorAction SilentlyContinue | % {$_.PSChildName, $_.PSPath+"`n"}

# Registry - Software List

# System Registries
"`n`n => Checking System Registries SOFTWARE"
Get-Item -Path HKLM:\Software\* | % { $_.Name }

"`n`n => Checking System Registries Startup"
Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        "`n`n => Checking User Registries SID: $j\Software"
        Get-Item -Path Registry::$j\Software\* -ErrorAction SilentlyContinue | % {$_.Name}
        "`n`n => Checking User Startup Registries SID: $j\Software\Microsoft\Windows\CurrentVersion\Run"
        #Get-ItemProperty -Path Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue
        Get-ItemProperty -Path Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue
    }
}

# Chrome History File
"`n`n => Checking for Chrome History Files"

$result = test-path -Path "C:\users\$username\appdata\local\google\chrome\User Data\Default\history"
if ($result -eq "True") {
    "Chrome History file in C:\users\$username\appdata\local\google\chrome\User Data\Default\history"
}

foreach ($i in 1..10) {
    $result = test-path -Path "C:\users\$username\appdata\local\google\chrome\User Data\Profile $i\history"
    if ($result -eq "True") {
        "Discovered Chrome History file in C:\users\$username\appdata\local\google\chrome\User Data\Profile $i\history"
    }
}

# Edge and IE History File
"`n`n => Checking for Internet Explorer / Edge History File"
$result = test-path -Path "C:\Users\$username\AppData\Local\Microsoft\Windows\WebCache\WebCacheV01.dat"
if ($result -eq "True") {
    "Internet Explorer/Microsoft Edge History file in C:\Users\$username\AppData\Local\Microsoft\Windows\WebCache\WebCacheV01.dat"
}

# Check for profile processes
"`n`n Checking Profile-based processes"
Get-Process | select Name, Id, Path | where {($_.Path -like "*appdata\local*") -or ($_.Path -like "*appdata\roaming*") -or ($_.Path -like "ProgramData")}

# Detect Browser Activity
"`n`n => Browsers Detected"
Get-Process chrome -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)" }
Get-Process iexplore -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)" }
Get-Process msedge -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)" }
Get-Process firefox -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)" }

# Running Services
"`n`n Checks for running services"
Get-Service | select Status, Name | where {$_.Status -eq "Running"} 
