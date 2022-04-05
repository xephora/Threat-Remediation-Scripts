# Investigate the following account below.  Please replace `<username>` with the target username below:

$username = "<USERNAME>"

# File System - Startups
"=> Checking Startup Locations"
"C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
gci -force "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
gci -force "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

# File System
"`n`n => Checking Root Dir"
"C:\"
gci -force C:\

"`n`n => Checking ProgramData"
"C:\ProgramData"
gci -force "C:\ProgramData"

# Antivirus Logs
"`n`n => Checking Symantec Local Antivirus Logs"
"C:\ProgramData\symantec\Symantec Endpoint Protection\currentversion\Data\Logs\av"
$result = test-path -Path "C:\ProgramData\symantec\Symantec Endpoint Protection\currentversion\Data\Logs\av"
if ($result -eq "True") {
	Get-ChildItem "C:\ProgramData\symantec\Symantec Endpoint Protection\currentversion\Data\Logs\av" | select Name,length
} else {
    "Symantec Endpoint doesn't seem to be on this system.."
}

# User profile
"`n`n => Checking User Profile"
"C:\Users\$username\"
gci -force "C:\Users\$username\"

"`n`n => downloaded executables, msi packages and zip, rar, 7z compressed folders"
"C:\Users\$username\downloads\"
gci -force "C:\Users\$username\downloads\*.exe"
gci -force "C:\Users\$username\downloads\*.msi"
gci -force "C:\Users\$username\downloads\*.zip"
gci -force "C:\Users\$username\downloads\*.rar"
gci -force "C:\Users\$username\downloads\*.7z"

# User profile application folders
"`n`n => Checking User's local application data"
"C:\Users\$username\appdata\local"
gci -force "C:\Users\$username\appdata\local"

"`n`n => Checking User's roaming application data"
"C:\Users\$username\appdata\roaming"
gci -force "C:\Users\$username\appdata\roaming"

# FileSystem Scheduled Tasks
"`n`n => Checking Scheduled Tasks"
"C:\windows\system32\tasks\"
gci -force "C:\windows\system32\tasks\"

# System Registry Scheduled tasks
"`n`n => Checking System Registries - Scheduled Tasks"
Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\*' -ErrorAction SilentlyContinue

# Registry - Software List
$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"

# System Registries
"`n`n => Checking System Registries SOFTWARE"
Get-Item -Path HKLM:\Software\*

"`n`n => Checking System Registries Startup"
Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue

foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        "`n`n => Checking User Registries SID: $j\Software"
        Get-Item -Path Registry::$j\Software\* -ErrorAction SilentlyContinue
        "`n`n => Checking User Startup Registries SID: $j\Software\Microsoft\Windows\CurrentVersion\Run"
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
Get-Process chrome -ErrorAction SilentlyContinue
Get-Process iexplore -ErrorAction SilentlyContinue
Get-Process msedge -ErrorAction SilentlyContinue
Get-Process firefox -ErrorAction SilentlyContinue

# Running Services
"`n`n Checks for running services"
Get-Service | select Status, Name | where {$_.Status -eq "Running"} 
