<#
.SYNOPSIS
    Unified remediation of unwanted browsers / browser-related adware (Windows, RMM friendly).

.DESCRIPTION
    Replaces the individual scripts of 1browser, OneBrowser, BBSK (SecureBrowser), Ouroborosbrowser,
    LiteBrowser, ShiftBrowser, Blazer, WebDiscoverBrowser, WaveBrowser, Epibrowser, BrowserAssistant,
    OneStart and OneLaunch.

    For every software of the $Definitions table the script:
      1. detects its artifacts (files, shortcuts, scheduled tasks, registry keys / values, running processes)
      2. removes them (tasks, processes, files, registry)
      3. re-runs the detection to confirm nothing is left

    Side effects are kept to a minimum:
      - processes are only stopped by PID, when their executable sits in a folder / is a file that is about to be
        removed (never by generic name such as node, setup, updater, browser, chromium, chrome...)
      - no other browser is ever closed
      - scheduled tasks are removed with the ScheduledTasks cmdlets (TaskCache is cleaned by Windows itself)
      - generic names (updater.lnk, "Startup Scheduler", Chrome-like Run value) are only removed when their content
        points to the targeted software
      - installers are only searched (exe / msi) in the Downloads and Desktop folders of each profile
      - one software failing never stops the others

    RMM output (Datto RMM UDF, HKLM\Software\CentraStage):
      $ListUdf  (default Custom50) : detected software, comma separated. "(KO)" is appended when something is left.
      $CountUdf (default Custom51) : number of software that were fully removed.

.PARAMETER ListUdf
    UDF name that receives the list of detected software.

.PARAMETER CountUdf
    UDF name that receives the number of software removed.

.PARAMETER DetectOnly
    Detect and report only, nothing is removed.

.NOTES
    Run as SYSTEM / administrator. Works from a 32 or 64 bit PowerShell 5.1+.
    Only the user hives that are currently loaded (logged on users) are cleaned, like the original scripts.
    The file is kept ASCII only on purpose (PowerShell 5.1 reads BOM-less files as ANSI).
#>
[CmdletBinding()]
param(
    [string]$ListUdf = 'Custom50',
    [string]$CountUdf = 'Custom51',
    [switch]$DetectOnly
)

# Datto RMM UDF values are limited to 255 characters
$UdfMaxLength = 255

# S-1-5-21-a-b-c-rid (local / domain) and S-1-12-1-a-b-c-d (Azure AD) user SIDs
$UserSidRegex = '^S-1-(?:5-21|12-1)(?:-\d+){4}$'

# Removal order: stop what can come back first, registry last
$KindOrder = @{ Task = 0; Process = 1; Path = 2; RegValue = 3; RegKey = 4 }

# ---------------------------------------------------------------------------------------------------------------
# Definitions
#   Dirs        machine wide folders / files (wildcards allowed)
#   UserPaths   relative to each user profile (wildcards allowed). String or @{ Path; LinkTargetLike }
#   Installers  exe / msi names (wildcards allowed) searched recursively in Downloads and Desktop of each profile
#   Tasks       scheduled task names (wildcards allowed). String or @{ Name; ActionLike }
#   HklmKeys    HKLM sub keys (native registry view, so WOW6432Node is explicit)
#   HklmValues  @{ Key; Names; DataLike } values to remove under an HKLM key
#   HkuKeys     sub keys relative to HKU\<sid>   (Software\Classes\... is the per user HKCU\Software\Classes)
#   HkuValues   @{ Key; Names; DataLike } values to remove under an HKU\<sid> key
#   DataLike (and LinkTargetLike / ActionLike) is a safeguard: the item is only removed when its content matches.
# ---------------------------------------------------------------------------------------------------------------
$RunKey = 'Software\Microsoft\Windows\CurrentVersion\Run'
$Uninstall = 'Software\Microsoft\Windows\CurrentVersion\Uninstall'
$StartMenu = 'AppData\Roaming\Microsoft\Windows\Start Menu\Programs'
$StartupDir = "$StartMenu\Startup"
$QuickLaunch = 'AppData\Roaming\Microsoft\Internet Explorer\Quick Launch'
$Pinned = "$QuickLaunch\User Pinned\TaskBar"

# $env:ProgramFiles / System32 are redirected for a 32 bit process on a 64 bit OS
$ProgFiles = if ($env:ProgramW6432) { $env:ProgramW6432 } else { $env:ProgramFiles }
$ProgFilesX86 = if (${env:ProgramFiles(x86)}) { ${env:ProgramFiles(x86)} } else { $ProgFiles }
$Sys32 = if ([Environment]::Is64BitOperatingSystem -and -not [Environment]::Is64BitProcess) { "$env:windir\sysnative" } else { "$env:windir\System32" }
$SystemProfile = "$Sys32\config\systemprofile"

$Definitions = @(
    @{
        Name       = '1browser'
        Dirs       = @("$ProgFiles\1browser*")
        UserPaths  = @('AppData\Local\1browser', 'Desktop\1Browser.lnk', "$QuickLaunch\1Browser.lnk", "$StartMenu\1Browser.lnk", "$Pinned\1Browser.lnk")
        Installers = @('1browser*.exe')
        Tasks      = @('1browserUser')
        HklmKeys   = @('SOFTWARE\WOW6432Node\1browser')
        HkuKeys    = @('Software\1browser', 'Software\Classes\1browserUpdate.Update3WebUser', "$Uninstall\1browser 1browser")
        HkuValues  = @(@{ Key = $RunKey; Names = @('1browserUpdaterTaskUser*') })
    },
    @{
        Name       = 'OneBrowser'
        UserPaths  = @('AppData\Local\OneBrowser', "$StartMenu\OneBrowser.lnk")
        Installers = @('OneBrowser*.exe', '*OneBrowser*.msi')
        Tasks      = @('OBUpdate*')
        HkuKeys    = @('Software\OneBrowser', "$Uninstall\OneBrowser")
    },
    @{
        Name      = 'BBSK/SecureBrowser'
        UserPaths = @('AppData\Roaming\BBSK', 'AppData\Roaming\Blaze Media Inc', 'AppData\Local\BlazeMedia', 'AppData\Roaming\BlazeMedia', "$QuickLaunch\Secure Browser.lnk")
        Tasks     = @('BB Updater Scheduler', 'BBSK Startup Scheduler', 'BlazeMediaUpdateTaskUser*')
        HkuKeys   = @('Software\BlazeMedia', 'Software\Blaze Media Inc', 'Software\Drake Media Inc.', 'Software\Clients\StartMenuInternet\Secure Browser*', "$Uninstall\BlazeMedia SecureBrowser")
        HkuValues = @(@{ Key = $RunKey; Names = @('BBUpdaterStartup', 'SKStartup', 'SKUpdater', 'BlazeMedia Update') })
    },
    @{
        Name       = 'Ouroborosbrowser'
        UserPaths  = @('AppData\Local\ouroborosbrowser-updater', 'AppData\Roaming\ouroborosbrowser', 'AppData\Local\Programs\ouroborosbrowser')
        Installers = @('*Ouroborosbrowser*.exe')
        HkuValues  = @(@{ Key = $RunKey; Names = @('Ouroborosbrowser') })
    },
    @{
        Name      = 'LiteBrowser'
        UserPaths = @('AppData\Roaming\LiteBrowser.org', 'AppData\Local\LiteBrowser', "$StartupDir\LiteBrowser.lnk")
        Tasks     = @('Launch LiteBrowser', 'LiteBrowser Updater')
        HkuKeys   = @('Software\LiteBrowser', 'Software\LiteBrowser.org')
    },
    @{
        Name       = 'ShiftBrowser'
        UserPaths  = @('AppData\Local\Shift', 'Desktop\Shift Browser.lnk', "$StartMenu\Shift\Shift Browser.lnk", "$StartMenu\Shift.lnk")
        Installers = @('Shift - *.exe')
        Tasks      = @('ShiftLaunchTask')
        HkuKeys    = @('Software\Shift', 'Software\Clients\StartMenuInternet\Shift', 'Software\Classes\ShiftHTML', "$Uninstall\{95fcf903-63b1-44bd-ab77-358a5bd30aae}_is1", 'Software\Classes\CLSID\{635EFA6F-08D6-4EC9-BD14-8A0FDE975159}')
        HkuValues  = @(
            @{ Key = $RunKey; Names = @('ShiftAutoLaunch_E5A4D1242AD7DFAA7BA68197713C983F') },
            @{ Key = $RunKey; Names = @('GoogleChromeAutoLaunch_E5964F24A764F40CAB0A4B52CD44BC66'); DataLike = '*\Shift\*' },
            @{ Key = 'Software\RegisteredApplications'; Names = @('Shift') }
        )
    },
    @{
        Name      = 'Blazer'
        UserPaths = @('AppData\Local\Blazer', 'Desktop\Blazer.lnk', "$QuickLaunch\Blazer.lnk", "$StartMenu\Blazer.lnk")
        Tasks     = @('BlazerBrowserStartupTask', 'BlazerBrowserUpdateTask')
        HklmKeys  = @('SOFTWARE\WOW6432Node\Blazer', 'SOFTWARE\Microsoft\Tracing\blazer_pdf_installer_Mz4jAePC_RASAPI32', 'SOFTWARE\Microsoft\Tracing\blazer_pdf_installer_Mz4jAePC_RASMANCS', 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Blazer')
        HkuKeys   = @('Software\Blazer', 'Software\Classes\AppUserModelId\Blazer.7SPNXAJ6RTUZWN3PPCU2UIIWXM', 'Software\Classes\BlazerHTM.7SPNXAJ6RTUZWN3PPCU2UIIWXM', 'Software\Classes\BlazerPDF.7SPNXAJ6RTUZWN3PPCU2UIIWXM', 'Software\Clients\StartMenuInternet\Blazer.7SPNXAJ6RTUZWN3PPCU2UIIWXM', "$Uninstall\Blazer")
        HkuValues = @(@{ Key = $RunKey; Names = @('BlazerAutoLaunch_*') })
    },
    @{
        Name       = 'WebDiscoverBrowser'
        Dirs       = @("$ProgFiles\WebDiscoverBrowser")
        UserPaths  = @('AppData\Local\WebDiscoverBrowser')
        Tasks      = @('WebDiscover Browser Launch Task', 'WebDiscover Browser Update Task')
        HklmValues = @(@{ Key = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run'; Names = @('WebDiscoverBrowser') })
        HkuKeys    = @('Software\WebDiscoverBrowser')
        HkuValues  = @(@{ Key = $RunKey; Names = @('WebDiscoverBrowser') })
    },
    @{
        Name       = 'WaveBrowser'
        Dirs       = @("$ProgFilesX86\Wavesor")
        UserPaths  = @('Wavesor Software', 'WebNavigatorBrowser', 'AppData\Local\WaveBrowser', 'AppData\Local\WebNavigatorBrowser', "$StartMenu\WaveBrowser.lnk", "$QuickLaunch\WaveBrowser.lnk", 'Desktop\WaveBrowser.lnk', "$Pinned\WaveBrowser.lnk")
        Installers = @('Wave Browser*.exe')
        Tasks      = @('Wavesor*', 'WaveBrowser*')
        HklmKeys   = @('SOFTWARE\Policies\Wavesor', 'SOFTWARE\WOW6432Node\Wavesor')
        HkuKeys    = @('Software\WaveBrowser', 'Software\Wavesor', 'Software\WebNavigatorBrowser', "$Uninstall\WaveBrowser", 'Software\Microsoft\Windows\CurrentVersion\App Paths\wavebrowser.exe', 'Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser', 'Software\Classes\CLSID\{9CD78CBC-FD21-4FFF-B452-9D792A58B7C4}\LocalServer32', 'Software\Clients\StartMenuInternet\WaveBrowser.5QMLTPZDDJG2BQZHV26QUN4ZK4', 'Software\Classes\WaveBrwsHTM*', 'Software\Classes\WavesorSWUpdater.*')
        HkuValues  = @(
            @{ Key = $RunKey; Names = @('Wavesor SWUpdater') },
            @{ Key = 'Software\RegisteredApplications'; Names = @('WaveBrowser.5QMLTPZDDJG2BQZHV26QUN4ZK4') }
        )
    },
    @{
        Name      = 'Epibrowser'
        UserPaths = @('AppData\Local\EPISoftware', "$StartMenu\EpiBrowser.lnk", "$StartMenu\EpiStart.lnk")
        Tasks     = @('EpiBrowserStartup*')
        HklmKeys  = @('SOFTWARE\Microsoft\MediaPlayer\ShimInclusionList\epibrowser.exe')
        HkuKeys   = @('Software\EPISoftware', "$Uninstall\EPISoftware EpiBrowser", 'Software\Classes\EPIHTML*', 'Software\Classes\EPIPDF*', 'Software\Clients\StartMenuInternet\EpiBrowser*', 'Software\Microsoft\Windows\CurrentVersion\App Paths\epibrowser.exe')
        HkuValues = @(@{ Key = $RunKey; Names = @('EpiBrowserStartup', 'EpiBrowserUpdate') })
    },
    @{
        Name      = 'BrowserAssistant'
        UserPaths = @('AppData\Roaming\Browser Assistant', "$StartupDir\BrowserAssistant.lnk", @{ Path = "$StartupDir\updater.lnk"; LinkTargetLike = '*Browser Assistant*' })
        Tasks     = @('BA Scheduler', 'D B Scheduler', 'D Edge C Scheduler', @{ Name = 'Startup Scheduler'; ActionLike = '*Browser Assistant*' })
        HkuKeys   = @('Software\Realistic Media Inc.')
        HkuValues = @(@{ Key = $RunKey; Names = @('BAStartup', 'BAUpdater') })
    },
    @{
        Name       = 'OneStart'
        Dirs       = @("$SystemProfile\AppData\Local\OneStart.ai", "$SystemProfile\PDFEditor")
        UserPaths  = @('AppData\Local\OneStart.ai', 'OneStart.ai', 'Desktop\OneStart.lnk', "$QuickLaunch\OneStart.lnk", "$StartMenu\OneStart.lnk", "$StartMenu\PDF Editor.lnk", 'AppData\Roaming\NodeJs', 'AppData\Roaming\PDF Editor')
        Installers = @('OneStart*.exe', '*OneStart*.msi')
        Tasks      = @('OneStartUser', 'OneStartAutoLaunchTask*', 'PDFEditorScheduledTask', 'PDFEditorUScheduledTask', 'sys_component_health_*')
        HklmKeys   = @('SOFTWARE\WOW6432Node\Microsoft\Tracing\OneStart_RASAPI32', 'SOFTWARE\WOW6432Node\Microsoft\Tracing\OneStart_RASMANCS', 'SOFTWARE\Microsoft\MediaPlayer\ShimInclusionList\onestart.exe')
        HkuKeys    = @(
            'Software\Clients\StartMenuInternet\OneStart.IOZDYLUF4W5Y3MM3N77XMXEX6A',
            'Software\Clients\StartMenuInternet\OneStart.25VKDQVMIQGWARCLC23VYGDER4',
            'Software\OneStart.ai',
            "$Uninstall\OneStart.ai OneStart",
            'Software\PDFEditor',
            'Software\Classes\CLSID\{4DAC24AB-B340-4B7E-AD01-1504A7F59EEA}\LocalServer32',
            'Software\Classes\CLSID\{75828ED1-7BE8-45D0-8950-AA85CBF74510}\LocalServer32',
            'Software\Classes\CLSID\{A2C6CB58-C076-425C-ACB7-6D19D64428CD}\LocalServer32',
            'Software\Classes\CLSID\{A45DDD96-C17C-50A3-BD69-8D064F864B24}\LocalServer32',
            'Software\Classes\CLSID\{B5B6376D-5E59-5CB2-A34D-617C21A3A240}\LocalServer32',
            'Software\Classes\OneStart.aiUpdate.Update3WebUser',
            'Software\Classes\OSBHTML.25VKDQVMIQGWARCLC23VYGDER4'
        )
        HkuValues  = @(
            @{ Key = $RunKey; Names = @('OneStartUpdate', 'OneStartBarUpdate', 'OneStartBar', 'OneStart', 'OneStartChromium', 'OneStartUpdaterTaskUser*', 'PDFEditor*') },
            @{ Key = 'Software\RegisteredApplications'; Names = @('OneStart*') }
        )
    },
    @{
        Name       = 'OneLaunch'
        UserPaths  = @('AppData\Local\OneLaunch', "$StartMenu\OneLaunch", "$StartupDir\OneLaunch.lnk", "$StartupDir\OneLaunchChromium.lnk", "$StartupDir\OneLaunchUpdater.lnk", 'Desktop\OneLaunch.lnk')
        Installers = @('OneLaunch*.exe')
        Tasks      = @('OneLaunchLaunchTask', 'ChromiumLaunchTask', 'OneLaunchUpdateTask')
        HklmKeys   = @('SOFTWARE\Microsoft\Tracing\onelaunch_RASMANCS', 'SOFTWARE\Microsoft\Tracing\onelaunch_RASAPI32')
        HkuKeys    = @("$Uninstall\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1", 'Software\OneLaunch', 'Software\Classes\OneLaunchHTML')
        HkuValues  = @(
            @{ Key = $RunKey; Names = @('OneLaunch', 'OneLaunchChromium', 'OneLaunchUpdater') },
            @{ Key = 'Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts'; Names = @('OneLaunchHTML_.pdf', 'OneLaunch') },
            @{ Key = 'Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppBadgeUpdated'; Names = @('OneLaunchHTML_.pdf', 'OneLaunch') },
            @{ Key = 'Software\RegisteredApplications'; Names = @('OneLaunchHTML_.pdf', 'OneLaunch') }
        )
    }
)

# ---------------------------------------------------------------------------------------------------------------
# Registry helpers (.NET API: explicit native view, wildcard support per key segment, no provider quirks)
# ---------------------------------------------------------------------------------------------------------------
function Open-RegistryBase {
    param([string]$Hive)
    $view = if ([Environment]::Is64BitOperatingSystem) { [Microsoft.Win32.RegistryView]::Registry64 } else { [Microsoft.Win32.RegistryView]::Default }
    return [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]$Hive, $view)
}

function Join-RegistryPath {
    param([string]$Prefix, [string]$Name)
    if ($Prefix) { return "$Prefix\$Name" }
    return $Name
}

# Returns the existing sub keys matching $Pattern (wildcards allowed in any segment)
function Find-RegistryKey {
    param($Base, [string]$Pattern)

    $current = @('')
    foreach ($segment in $Pattern.Split('\')) {
        $next = @()
        foreach ($prefix in $current) {
            $parent = $null
            try {
                $parent = if ($prefix) { $Base.OpenSubKey($prefix) } else { $Base }
                if ($null -eq $parent) { continue }
                if ($segment -match '[\*\?\[]') {
                    foreach ($name in $parent.GetSubKeyNames()) {
                        if ($name -like $segment) { $next += Join-RegistryPath -Prefix $prefix -Name $name }
                    }
                }
                else {
                    $child = $parent.OpenSubKey($segment)
                    if ($child) {
                        $child.Close()
                        $next += Join-RegistryPath -Prefix $prefix -Name $segment
                    }
                }
            }
            catch { }
            finally {
                if ($prefix -and $parent) { $parent.Close() }
            }
        }
        $current = $next
        if ($current.Count -eq 0) { break }
    }
    return $current
}

# Returns the names of the values of $KeyPath matching $Names (and $DataLike when given)
function Find-RegistryValue {
    param($Base, [string]$KeyPath, [string[]]$Names, [string]$DataLike)

    $key = $null
    try { $key = $Base.OpenSubKey($KeyPath) } catch { }
    if ($null -eq $key) { return @() }

    $values = @()
    try {
        foreach ($valueName in $key.GetValueNames()) {
            if (-not $valueName) { continue }
            $hit = $false
            foreach ($pattern in $Names) {
                if ($valueName -like $pattern) { $hit = $true; break }
            }
            if (-not $hit) { continue }
            if ($DataLike -and ([string]$key.GetValue($valueName) -notlike $DataLike)) { continue }
            $values += $valueName
        }
    }
    catch { }
    finally { $key.Close() }
    return $values
}

function Remove-RegistryKey {
    param($Base, [string]$KeyPath)
    $index = $KeyPath.LastIndexOf('\')
    if ($index -lt 1) { return }
    $parent = $Base.OpenSubKey($KeyPath.Substring(0, $index), $true)
    if ($null -eq $parent) { return }
    try { $parent.DeleteSubKeyTree($KeyPath.Substring($index + 1), $false) }
    finally { $parent.Close() }
}

function Remove-RegistryValue {
    param($Base, [string]$KeyPath, [string]$Name)
    $key = $Base.OpenSubKey($KeyPath, $true)
    if ($null -eq $key) { return }
    try { $key.DeleteValue($Name, $false) }
    finally { $key.Close() }
}

# ---------------------------------------------------------------------------------------------------------------
# Detection helpers
# ---------------------------------------------------------------------------------------------------------------
function Get-DefinitionList {
    param([hashtable]$Definition, [string]$Key)
    if ($Definition.ContainsKey($Key)) { return @($Definition[$Key]) }
    return @()
}

# Definition entries are either a plain string or a hashtable (with a safeguard)
function ConvertTo-Spec {
    param($Entry, [string]$Key)
    if ($Entry -is [hashtable]) { return $Entry }
    return @{ $Key = $Entry }
}

function Get-UserProfilePath {
    $paths = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)

    $skip = @('Public', 'Default', 'Default User', 'All Users', 'defaultuser0')
    foreach ($dir in @(Get-ChildItem -LiteralPath "$env:SystemDrive\Users" -Directory -Force -ErrorAction SilentlyContinue)) {
        if ($skip -contains $dir.Name) { continue }
        if ($dir.Attributes -band [IO.FileAttributes]::ReparsePoint) { continue }
        [void]$paths.Add($dir.FullName)
    }

    # profiles that live outside of C:\Users
    $list = $null
    try { $list = $script:HklmBase.OpenSubKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList') } catch { }
    if ($list) {
        foreach ($sid in $list.GetSubKeyNames()) {
            if ($sid -notmatch $UserSidRegex) { continue }
            $profileKey = $list.OpenSubKey($sid)
            if ($null -eq $profileKey) { continue }
            $path = [string]$profileKey.GetValue('ProfileImagePath')
            $profileKey.Close()
            if ($path -and (Test-Path -LiteralPath $path)) { [void]$paths.Add($path.TrimEnd('\')) }
        }
        $list.Close()
    }
    return @($paths)
}

function Get-LoadedUserSid {
    $sids = @()
    try {
        foreach ($name in $script:HkuBase.GetSubKeyNames()) {
            if ($name -match $UserSidRegex) { $sids += $name }
        }
    }
    catch { }
    return $sids
}

# Installers are only looked for in Downloads and Desktop, and only exe / msi files
function Get-InstallerIndex {
    param([string[]]$ProfilePath)
    $index = @()
    foreach ($root in $ProfilePath) {
        foreach ($folder in 'Downloads', 'Desktop') {
            $dir = Join-Path $root $folder
            if (-not (Test-Path -LiteralPath $dir)) { continue }
            $index += @(Get-ChildItem -LiteralPath $dir -Recurse -File -Force -ErrorAction SilentlyContinue |
                    Where-Object { $_.Extension -in '.exe', '.msi' })
        }
    }
    return $index
}

function Get-AllScheduledTask {
    if (-not (Get-Command -Name Get-ScheduledTask -ErrorAction SilentlyContinue)) { return @() }
    return @(Get-ScheduledTask -ErrorAction SilentlyContinue)
}

function New-RemediationContext {
    $profiles = @(Get-UserProfilePath)
    return [pscustomobject]@{
        Profiles   = $profiles
        Sids       = @(Get-LoadedUserSid)
        Installers = @(Get-InstallerIndex -ProfilePath $profiles)
        Tasks      = @(Get-AllScheduledTask)
    }
}

function Test-ShortcutTarget {
    param([string]$Path, [string]$Like)
    try {
        $shell = New-Object -ComObject WScript.Shell
        $link = $shell.CreateShortcut($Path)
        return ("$($link.TargetPath) $($link.Arguments)" -like $Like)
    }
    catch { return $false }
}

# Running processes whose executable is in one of $Directories or is one of $Files (never matched by name)
function Find-ProcessUsingPath {
    param([string[]]$Directories, [string[]]$Files)

    if (@($Directories).Count -eq 0 -and @($Files).Count -eq 0) { return @() }
    $prefixes = @($Directories | ForEach-Object { $_.TrimEnd('\') + '\' })

    $found = @()
    foreach ($process in @(Get-CimInstance -ClassName Win32_Process -ErrorAction SilentlyContinue)) {
        $exe = [string]$process.ExecutablePath
        if (-not $exe -or $process.ProcessId -eq $PID) { continue }
        $hit = $false
        foreach ($prefix in $prefixes) {
            if ($exe.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { $hit = $true; break }
        }
        if (-not $hit) {
            foreach ($file in $Files) {
                if ($exe.Equals($file, [StringComparison]::OrdinalIgnoreCase)) { $hit = $true; break }
            }
        }
        if ($hit) {
            $found += [pscustomobject]@{ Kind = 'Process'; Label = "process $($process.ProcessId) -> $exe"; ProcessId = [int]$process.ProcessId }
        }
    }
    return $found
}

# All the artifacts of one software that currently exist on the machine
function Find-Artifact {
    param([hashtable]$Definition, $Context)

    $artifacts = New-Object System.Collections.Generic.List[object]
    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)

    # files, folders, shortcuts
    $specs = New-Object System.Collections.Generic.List[hashtable]
    foreach ($dir in (Get-DefinitionList $Definition 'Dirs')) { $specs.Add(@{ Path = $dir }) }
    foreach ($root in $Context.Profiles) {
        foreach ($entry in (Get-DefinitionList $Definition 'UserPaths')) {
            $spec = ConvertTo-Spec -Entry $entry -Key 'Path'
            $specs.Add(@{ Path = (Join-Path ([WildcardPattern]::Escape($root)) $spec.Path); LinkTargetLike = $spec.LinkTargetLike })
        }
    }

    $directories = New-Object System.Collections.Generic.List[string]
    $files = New-Object System.Collections.Generic.List[string]
    foreach ($spec in $specs) {
        foreach ($item in @(Get-Item -Path $spec.Path -Force -ErrorAction SilentlyContinue)) {
            if ($spec.LinkTargetLike -and -not (Test-ShortcutTarget -Path $item.FullName -Like $spec.LinkTargetLike)) { continue }
            if (-not $seen.Add($item.FullName)) { continue }
            if ($item.PSIsContainer) { $directories.Add($item.FullName) } else { $files.Add($item.FullName) }
            $artifacts.Add([pscustomobject]@{ Kind = 'Path'; Label = $item.FullName; Target = $item.FullName })
        }
    }
    foreach ($glob in (Get-DefinitionList $Definition 'Installers')) {
        foreach ($installer in $Context.Installers) {
            if ($installer.Name -notlike $glob) { continue }
            if (-not (Test-Path -LiteralPath $installer.FullName)) { continue }
            if (-not $seen.Add($installer.FullName)) { continue }
            $files.Add($installer.FullName)
            $artifacts.Add([pscustomobject]@{ Kind = 'Path'; Label = $installer.FullName; Target = $installer.FullName })
        }
    }

    foreach ($process in (Find-ProcessUsingPath -Directories $directories.ToArray() -Files $files.ToArray())) { $artifacts.Add($process) }

    # scheduled tasks
    foreach ($entry in (Get-DefinitionList $Definition 'Tasks')) {
        $spec = ConvertTo-Spec -Entry $entry -Key 'Name'
        foreach ($task in $Context.Tasks) {
            if ($task.TaskName -notlike $spec.Name) { continue }
            if ($spec.ActionLike) {
                $command = (@($task.Actions) | ForEach-Object { "$($_.Execute) $($_.Arguments)" }) -join ' '
                if ($command -notlike $spec.ActionLike) { continue }
            }
            $artifacts.Add([pscustomobject]@{ Kind = 'Task'; Label = "task $($task.TaskPath)$($task.TaskName)"; Target = $task.TaskName; TaskPath = $task.TaskPath })
        }
    }

    # registry
    foreach ($keyPath in (Get-DefinitionList $Definition 'HklmKeys')) {
        foreach ($found in @(Find-RegistryKey -Base $script:HklmBase -Pattern $keyPath)) {
            $artifacts.Add([pscustomobject]@{ Kind = 'RegKey'; Label = "HKLM\$found"; Hive = 'HKLM'; KeyPath = $found })
        }
    }
    foreach ($spec in (Get-DefinitionList $Definition 'HklmValues')) {
        foreach ($name in @(Find-RegistryValue -Base $script:HklmBase -KeyPath $spec.Key -Names $spec.Names -DataLike $spec.DataLike)) {
            $artifacts.Add([pscustomobject]@{ Kind = 'RegValue'; Label = "HKLM\$($spec.Key) [$name]"; Hive = 'HKLM'; KeyPath = $spec.Key; ValueName = $name })
        }
    }
    foreach ($sid in $Context.Sids) {
        foreach ($keyPath in (Get-DefinitionList $Definition 'HkuKeys')) {
            foreach ($found in @(Find-RegistryKey -Base $script:HkuBase -Pattern "$sid\$keyPath")) {
                $artifacts.Add([pscustomobject]@{ Kind = 'RegKey'; Label = "HKU\$found"; Hive = 'HKU'; KeyPath = $found })
            }
        }
        foreach ($spec in (Get-DefinitionList $Definition 'HkuValues')) {
            foreach ($name in @(Find-RegistryValue -Base $script:HkuBase -KeyPath "$sid\$($spec.Key)" -Names $spec.Names -DataLike $spec.DataLike)) {
                $artifacts.Add([pscustomobject]@{ Kind = 'RegValue'; Label = "HKU\$sid\$($spec.Key) [$name]"; Hive = 'HKU'; KeyPath = "$sid\$($spec.Key)"; ValueName = $name })
            }
        }
    }

    return $artifacts.ToArray()
}

# ---------------------------------------------------------------------------------------------------------------
# Removal
# ---------------------------------------------------------------------------------------------------------------
function Remove-Artifact {
    param($Artifact)
    try {
        switch ($Artifact.Kind) {
            'Task' {
                Unregister-ScheduledTask -TaskName $Artifact.Target -TaskPath $Artifact.TaskPath -Confirm:$false -ErrorAction Stop
            }
            'Process' {
                Stop-Process -Id $Artifact.ProcessId -Force -ErrorAction Stop
                Wait-Process -Id $Artifact.ProcessId -Timeout 5 -ErrorAction SilentlyContinue
            }
            'Path' {
                # a second pass lets the file handles of a just stopped process go away
                for ($attempt = 1; $attempt -le 2; $attempt++) {
                    if (-not (Test-Path -LiteralPath $Artifact.Target)) { break }
                    Remove-Item -LiteralPath $Artifact.Target -Recurse -Force -ErrorAction SilentlyContinue
                    if ((Test-Path -LiteralPath $Artifact.Target) -and $attempt -lt 2) { Start-Sleep -Seconds 2 }
                }
            }
            'RegKey' {
                $base = if ($Artifact.Hive -eq 'HKLM') { $script:HklmBase } else { $script:HkuBase }
                Remove-RegistryKey -Base $base -KeyPath $Artifact.KeyPath
            }
            'RegValue' {
                $base = if ($Artifact.Hive -eq 'HKLM') { $script:HklmBase } else { $script:HkuBase }
                Remove-RegistryValue -Base $base -KeyPath $Artifact.KeyPath -Name $Artifact.ValueName
            }
        }
    }
    catch { }
}

# Detect, remove, verify one software
function Invoke-SoftwareRemediation {
    param([hashtable]$Definition, $Context)

    $result = [pscustomobject]@{ Name = $Definition.Name; Detected = $false; Removed = $false; Leftovers = @() }

    $found = @(Find-Artifact -Definition $Definition -Context $Context)
    if ($found.Count -eq 0) { return $result }

    $result.Detected = $true
    Write-Host "[DETECTED] $($Definition.Name)"
    foreach ($artifact in $found) { Write-Host "    $($artifact.Label)" }
    if ($DetectOnly) { return $result }

    try {
        foreach ($artifact in ($found | Sort-Object -Property @{ Expression = { $KindOrder[$_.Kind] } })) {
            Remove-Artifact -Artifact $artifact | Out-Null
        }
        $Context.Tasks = @(Get-AllScheduledTask)
        $left = @(Find-Artifact -Definition $Definition -Context $Context)
        $result.Leftovers = @($left | ForEach-Object { $_.Label })
    }
    catch {
        $result.Leftovers = @("error: $($_.Exception.Message)")
    }

    if ($result.Leftovers.Count -eq 0) {
        $result.Removed = $true
        Write-Host "[REMOVED] $($Definition.Name)"
    }
    else {
        Write-Host "[FAILED] $($Definition.Name)"
        foreach ($label in $result.Leftovers) { Write-Host "    Failed to remove $($Definition.Name) -> $label" }
    }
    return $result
}

function Invoke-BrowserRemediation {
    $script:HklmBase = Open-RegistryBase -Hive 'LocalMachine'
    $script:HkuBase = Open-RegistryBase -Hive 'Users'

    $detected = New-Object System.Collections.Generic.List[string]
    $removedCount = 0
    $failed = $false
    try {
        $context = New-RemediationContext
        foreach ($definition in $Definitions) {
            try {
                $result = Invoke-SoftwareRemediation -Definition $definition -Context $context
            }
            catch {
                Write-Host "[ERROR] $($definition.Name): $($_.Exception.Message)"
                $failed = $true
                continue
            }
            if (-not $result.Detected) { continue }
            if ($result.Removed) { $removedCount++; $detected.Add($result.Name) }
            elseif ($DetectOnly) { $detected.Add($result.Name) }
            else { $failed = $true; $detected.Add("$($result.Name) (KO)") }
        }
    }
    finally {
        $script:HklmBase.Close()
        $script:HkuBase.Close()
    }

    return [pscustomobject]@{ DetectedList = ($detected -join ', '); UninstalledCount = [int]$removedCount; Failed = $failed }
}

# ---------------------------------------------------------------------------------------------------------------
# RMM output
# ---------------------------------------------------------------------------------------------------------------
function Format-UdfText {
    param([string]$Text, [int]$MaxLength)
    if ($Text.Length -le $MaxLength) { return $Text }
    $cut = $Text.Substring(0, $MaxLength - 3)
    $index = $cut.LastIndexOf(', ')
    if ($index -gt 0) { $cut = $cut.Substring(0, $index) }
    return "$cut..."
}

function Publish-RmmResult {
    param([string]$DetectedList, [int]$UninstalledCount)

    Write-Host "Detected    : $DetectedList"
    Write-Host "Uninstalled : $UninstalledCount"

    if (-not (Test-Path -Path 'HKLM:\Software\CentraStage')) {
        Write-Host 'HKLM:\Software\CentraStage not found, UDFs not written.'
        return
    }
    $result = Format-UdfText -Text $DetectedList -MaxLength $UdfMaxLength
    new-itemProperty -Path "HKLM:\Software\CentraStage" -Name $ListUdf -PropertyType String -Value $result -Force | Out-Null
    $result = [string]$UninstalledCount
    new-itemProperty -Path "HKLM:\Software\CentraStage" -Name $CountUdf -PropertyType String -Value $result -Force | Out-Null
}

# Dot-sourcing the file only loads the functions (no action)
if ($MyInvocation.InvocationName -ne '.') {
    $outcome = Invoke-BrowserRemediation
    Publish-RmmResult -DetectedList $outcome.DetectedList -UninstalledCount $outcome.UninstalledCount
    if ($outcome.Failed) { exit 1 }
    exit 0
}
