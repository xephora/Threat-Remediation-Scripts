# investigate the following account below.  Please replace username with the target account.
$username = "USERNAME"

# File System - Startups
"[+]  Checking Start Menu Startup"
$folders = @(
    "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
)
$results = @()

foreach ($folder in $folders) {
    Get-ChildItem -Path $folder -Filter "*.lnk" -Force -ErrorAction SilentlyContinue | ForEach-Object {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($_.FullName)
        $targetPath = $shortcut.TargetPath

        $result = @{
            'ShortcutPath' = $_.FullName
            'TargetPath'   = $targetPath
        }
        $results += $result
    }
}
$results | ConvertTo-Json

# File System - Program Shortcuts
"[+]  Checking Start Menu Location"
$folders = @(
    "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
)
$results = @()

foreach ($folder in $folders) {
    Get-ChildItem -Path $folder -Filter "*.lnk" -Force -ErrorAction SilentlyContinue | ForEach-Object {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($_.FullName)
        $targetPath = $shortcut.TargetPath

        $result = @{
            'ShortcutPath' = $_.FullName
            'TargetPath'   = $targetPath
        }
        $results += $result
    }
}
$results | ConvertTo-Json

# File System
"`n`n [+]  Checking Root Dir"
"C:\"
gci C:\ -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking ProgramData"
"C:\ProgramData"
gci "C:\ProgramData" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking Common Files"
"C:\program files\Common Files"
gci "C:\program files\Common Files" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking 32bit Common Files"
"C:\program files\Common Files (x86)"
gci "C:\program files (x86)\Common Files" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking Defender Antivirus Logs"
"C:\ProgramData\Microsoft\Windows Defender\Support"
$result = test-path -Path "C:\ProgramData\Microsoft\Windows Defender\Support"
if ($result -eq "True") {
	gci "C:\ProgramData\Microsoft\Windows Defender\Support" -fi "*.log" -force -ErrorAction SilentlyContinue | % { $_.FullName, "Size: $($_.length)"}
} else {
    "Failed to discover Defender.."
}

# Public profile
"`n`n [+]  Checking Public Profile"
"C:\Users\public"
gci "C:\Users\public\" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking Public Desktop"
"C:\Users\public\Desktop"
gci "C:\Users\public\Desktop" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# User profile
"`n`n [+]  downloaded executables, msi packages and zip, rar, 7z compressed folders"
$folders = @("Downloads", "Desktop", "Documents")
$extensions = @("*.exe", "*.msi", "*.rar", "*.7z", "*.zip", "*.iso", "*.vhd")

foreach ($folder in $folders) {
    $folderPath = "C:\users\$username\$folder"
    $fileFound = $false
    
    foreach ($extension in $extensions) {
        $files = Get-ChildItem -Path $folderPath -Recurse -Force -Filter $extension -ErrorAction SilentlyContinue
        if ($files) {
            $fileFound = $true
            break
        }
    }
    
    if ($fileFound) {
        "`n$folderPath`n------------------------------------------------" 
        foreach ($extension in $extensions) {
            Get-ChildItem -Path $folderPath -Recurse -Force -Filter $extension -ErrorAction SilentlyContinue | ForEach-Object {
                $_.FullName
            }
        }
    }
}

# User profile application folders
"`n`n [+]  Checking User's local application data"
"C:\Users\$username\appdata\local"
gci "C:\Users\$username\appdata\local" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking User's roaming application data"
"C:\Users\$username\appdata\roaming"
gci "C:\Users\$username\appdata\roaming" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Local Microsoft directory (Solarmarker Backdoor Drop path)"
"C:\users\$username\AppData\Local\Microsoft"
gci "C:\users\$username\AppData\Local\Microsoft" -force -ErrorAction SilentlyContinue | % { $_.FullName}

"`n`n [+]  Roaming Microsoft directory (Solarmarker Backdoor Common Drop path)"
"C:\users\$username\AppData\Roaming\Microsoft"
gci "C:\users\$username\AppData\Roaming\Microsoft" -force -ErrorAction SilentlyContinue | % { $_.FullName }

$exists = test-path "C:\Users\$username\appdata\local\programs"
if ($exists) {
    "`n`n Checking User's local Program directory"
    "C:\Users\$username\appdata\local\programs"
    gci "C:\users\$username\AppData\Local\programs" -force -ErrorAction SilentlyContinue | % { $_.FullName}
}

# FileSystem Scheduled Tasks
"`n`n [+]  Checking Scheduled Tasks"
"C:\windows\system32\tasks\"
gci "C:\windows\system32\tasks\" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n Checking Scheduled Tasks content (high level)"
$taskFolderPath = 'C:\Windows\System32\Tasks'

Get-ChildItem -Path $taskFolderPath -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $taskXml = [xml](Get-Content $_.FullName -ErrorAction SilentlyContinue)
        $taskInfo = @{
            'TaskName'  = $_.Name
            'Author'    = $taskXml.Task.RegistrationInfo.Author
            'UserId'    = $taskXml.Task.Principals.Principal.UserId
            'Command'   = $taskXml.Task.Actions.Exec.Command
            'Arguments' = $taskXml.Task.Actions.Exec.Arguments
        }
        if ($taskInfo.Command){
            $taskInfoJson = $taskInfo | ConvertTo-Json
            $taskInfoJson
            "--------------------------------------------------------------------------"
        }
    } catch {
    }
}

# System Registry Scheduled tasks
"`n`n [+]  Checking System Registries - Scheduled Tasks"
"Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE"
(get-item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE").GetSubKeyNames()

# System Registries
"`n`n [+]  Checking System Registries SOFTWARE"
Get-Item -Path HKLM:\Software\* | % { $_.Name }

"`n`n [+]  Checking System Registries Startup"
"HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
(get-item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Run).GetValueNames()

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        "`n`n [+]  Checking User Registries SID"
        "$j\Software"
        (Get-Item -Path Registry::$j\Software).GetSubKeyNames()
        "`n`n [+]  Checking User Startup Registries SID"
        "$j\Software\Microsoft\Windows\CurrentVersion\Run"
        (Get-Item -Path Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run).GetValueNames()
    }
}

"`n`n [+] Checking Uninstall Keys"
Get-ChildItem "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" `
| ForEach-Object {
    $keyName = $_.PSChildName
    $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
    
    if ($props.DisplayName) {
        [PSCustomObject]@{
            KeyName         = $keyName
            DisplayName     = $props.DisplayName
            DisplayVersion  = $props.DisplayVersion
            Publisher       = $props.Publisher
            UninstallString = $props.UninstallString
        }
    }
}|convertto-json

"`n`n[+] Chrome History files"
$exists=test-path "C:\users\$username\AppData\Local\google\Chrome\User Data"
if ($exists) {
    $historyFilePaths=@(gci "C:\users\$username\AppData\Local\google\Chrome\User Data" -r -fi "history" | % { $_.FullName }); 
    foreach ($filePath in $historyFilePaths) {
        if (test-path $filepath) {
        $fileInfo = Get-Item $filePath | Select-Object FullName, Length, CreationTime, LastWriteTime
        $fileSizeMB = $fileInfo.Length / 1MB
        Write-Output "File path: $($fileInfo.FullName)"
        Write-Output "File size: $fileSizeMB MB"
        Write-Output "Creation date: $($fileInfo.CreationTime)"
        Write-Output "Modification date: $($fileInfo.LastWriteTime)"
        Write-Output "------------------------"
        }
    }
}

# Edge and IE History File
"`n`n[+]  Checking for Internet Explorer / Edge History File"
$IEHistoryfile = "C:\Users\$username\AppData\Local\Microsoft\Windows\WebCache\WebCacheV01.dat"
if (test-path $IEHistoryfile) {
	"Internet Explorer/Microsoft Edge History file in C:\Users\$username\AppData\Local\Microsoft\Windows\WebCache\WebCacheV01.dat"
	$fileInfo = Get-Item $IEHistoryfile | Select-Object FullName, Length, CreationTime, LastWriteTime
	$fileSizeMB = $IEHistoryfile.Length / 1MB
	Write-Output "File path: $($fileInfo.FullName)"
	Write-Output "File size: $fileSizeMB MB"
	Write-Output "Creation date: $($fileInfo.CreationTime)"
	Write-Output "Modification date: $($fileInfo.LastWriteTime)"
	Write-Output "------------------------"
}

# Added chrome-based Edge
$exists=test-path "C:\users\$username\AppData\Local\Microsoft\Edge\User Data"
if ($exists) {
    $historyFilePaths=@(gci "C:\users\$username\AppData\Local\Microsoft\Edge\User Data" -r -fi "history" | % { $_.FullName }); 
    foreach ($filePath in $historyFilePaths) {
        if (test-path $filepath) {
        $fileInfo = Get-Item $filePath | Select-Object FullName, Length, CreationTime, LastWriteTime
        $fileSizeMB = $fileInfo.Length / 1MB
        Write-Output "File path: $($fileInfo.FullName)"
        Write-Output "File size: $fileSizeMB MB"
        Write-Output "Creation date: $($fileInfo.CreationTime)"
        Write-Output "Modification date: $($fileInfo.LastWriteTime)"
        Write-Output "------------------------"
        }
    }
}

# Check for profile processes
"`n`n [+] Checking Profile-based processes"
Get-Process |
    Select-Object -Property Name, Id, Path |
    Where-Object {
        ($_.Path -ilike "*\AppData\Local*") -or
        ($_.Path -ilike "*\AppData\Roaming*") -or
        ($_.Path -ilike "ProgramData*")
}

# Detect Browser Activity
"`n`n [+]  Browsers Detected"
$browserNames = @("chrome", "iexplore", "msedge", "firefox")

foreach ($browser in $browserNames) {
    Get-Process $browser -ErrorAction SilentlyContinue | ForEach-Object {
        $_.ProcessName,
        "PID: $($_.Id)",
        $_.Description,
        $_.Company,
        $_.Path
    }
}

# Enumerate Disk
"`n`n[+] Checking Disks"
$logicalDisks = Get-WmiObject -Class Win32_LogicalDisk
$cdromDrives = Get-WmiObject -Class Win32_CDROMDrive

foreach ($disk in $logicalDisks) {
    $diskInfo = @{
        'DeviceID'    = $disk.DeviceID
        'VolumeName'  = $disk.VolumeName
        'Description' = $disk.Description
    }
    
    $cdromDrive = $cdromDrives | Where-Object { $_.Drive -eq $disk.DeviceID }
    if ($cdromDrive) {
        $diskInfo['MountedISO'] = $cdromDrive.MediaLoaded -and $cdromDrive.VolumeName
    }

    $diskInfo | ConvertTo-Json
}

"`n`n[+] Enuerating PowerShell History"
$filePath = "C:\Users\$username\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

if (Test-Path $filePath) {
    $file = Get-Item $filePath
    $sizeInMB = [Math]::Round($file.Length / 1MB, 2)

    Write-Host "Path: $($file.FullName)"
    Write-Host "Size (MB): $sizeInMB"
}

"`n`n [+] Enumerating Chrome Extensions"
if (test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\default") {
    $defaultExtensions = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\default\extensions" -r -fi "manifest.json" | % { $_.FullName})
    foreach ($extension in $defaultExtensions) {
        if (test-path $extension) {
            foreach ($dprofile in $extension) {
                $extid =  (($dprofile -split '\\extensions')[1] -split '\\')[1]
                $url = "https://chrome.google.com/webstore/detail/docs/"
                $eurl = "$($url)$($extid)"
                try {
                    $res = Invoke-WebRequest $eurl -ErrorAction Ignore
                    $content = $res.Content
                    $srange = $content.IndexOf("<title>")+"<title>".Length
                    $erange = $content.IndexOf("</title>")
                    $title = $content.Substring($srange,$erange - $srange)
                    "`nPath: $dprofile -> $title"
                } catch {
                    "`nPath: $dprofile ! Failed to detect!"
                }
            }
        }
    }
}

if (test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\Profile*") {
    $profiles = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\Profile*").Name
    foreach ($profile in $profiles) {
        if(test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\$profile") {
            "`n[+] chrome profile $profile on profile $username"
            $ProfilesExtensions = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\$profile\extensions" -r -fi "manifest.json" | % { $_.FullName})
            foreach ($cprofile in $ProfilesExtensions) {
                $extid =  (($cprofile -split '\\extensions')[1] -split '\\')[1]
                $url = "https://chrome.google.com/webstore/detail/docs/"
                $eurl = "$($url)$($extid)"
                try {
                    $res = Invoke-WebRequest $eurl -ErrorAction Ignore
                    $content = $res.Content
                    $srange = $content.IndexOf("<title>")+"<title>".Length
                    $erange = $content.IndexOf("</title>")
                    $title = $content.Substring($srange,$erange - $srange)
                    "`nPath: $cprofile -> $title"
                } catch {
                    "`nPath: $cprofile ! Failed to detect!"
                }
            }
        }
    }
}

"`n`n [+] Enumerating Temp Directory"
$tmpFiles = Get-ChildItem -Path $tempDir -Filter *.tmp
foreach ($file in $tmpFiles) {
    try {
        $bytes = New-Object byte[] 4
        $fileStream = [System.IO.File]::OpenRead($file.FullName)
        $fileStream.Read($bytes, 0, 4) | Out-Null
        $fileStream.Close()
        $fileSignature = ($bytes | ForEach-Object { $_.ToString("X2") }) -join ''

        $fileType = "Unknown"
        foreach ($signature in $fileSignatures.Keys) {
            if ($fileSignature.StartsWith($signature)) {
                $fileType = $fileSignatures[$signature]
                break
            }
        }

        $versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($file.FullName)
        if ($versionInfo -and $versionInfo.OriginalFilename) {
            Write-Host "File: $($file.Name), Original File: $($versionInfo.OriginalFilename), Type: $fileType"
        } else {
            "File: $($file.Name), Type: $fileType"
        }
    } catch {
        "File: $($file.Name) is currently in use and cannot be processed."
    }
}

"`n`n[+] Checking for AppxPacakages"
Get-AppxPackage `
| Where-Object { $_.Name -like "*Microsoft*" } `
| Select-Object Name, PackageFullName, InstallLocation `
| ConvertTo-Json

# Running Services
"`n`n[+] Checking for running services"
Get-Service | Where-Object { $_.Status -eq "Running" } | ForEach-Object {
    $serviceInfo = Get-WmiObject -Class Win32_Service -Filter "Name='$($_.Name)'"
    @{
        'ServiceName'   = $_.Name
        'DisplayName'   = $_.DisplayName
        'Status'        = $_.Status
        'CanStop'       = $_.CanStop
        'ServiceBinary' = $serviceInfo.PathName
    }
} | ConvertTo-Json
