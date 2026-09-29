#################
# CONFIGURATION #
#################
$TargetFile = "PATH_TO_FILE"
$LogFile = "C:\Windows\Temp\EnumLockedFile_output.log"
$ExcludedProcessNames = @(
    'powershell',
    'powershell_ise',
    'pwsh',
    'cmd'
)
if (-not (Test-Path $TargetFile)) {
    throw "Target file does not exist: $TargetFile"
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class RestartManager
{
    [StructLayout(LayoutKind.Sequential)]
    public struct RM_UNIQUE_PROCESS
    {
        public int dwProcessId;
        public System.Runtime.InteropServices.ComTypes.FILETIME ProcessStartTime;
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct RM_PROCESS_INFO
    {
        public RM_UNIQUE_PROCESS Process;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)]
        public string strAppName;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 64)]
        public string strServiceShortName;

        public uint ApplicationType;
        public uint AppStatus;
        public uint TSSessionId;

        [MarshalAs(UnmanagedType.Bool)]
        public bool bRestartable;
    }

    [DllImport("rstrtmgr.dll", CharSet = CharSet.Unicode)]
    public static extern int RmStartSession(
        out uint pSessionHandle,
        int dwSessionFlags,
        string strSessionKey);

    [DllImport("rstrtmgr.dll", CharSet = CharSet.Unicode)]
    public static extern int RmRegisterResources(
        uint dwSessionHandle,
        UInt32 nFiles,
        string[] rgsFilenames,
        UInt32 nApplications,
        IntPtr rgApplications,
        UInt32 nServices,
        string[] rgsServiceNames);

    [DllImport("rstrtmgr.dll")]
    public static extern int RmGetList(
        uint dwSessionHandle,
        out uint pnProcInfoNeeded,
        ref uint pnProcInfo,
        [In, Out] RM_PROCESS_INFO[] rgAffectedApps,
        ref uint lpdwRebootReasons);

    [DllImport("rstrtmgr.dll")]
    public static extern int RmEndSession(uint pSessionHandle);
}
"@

$sessionHandle = 0
$sessionKey = [Guid]::NewGuid().ToString()

$result = [RestartManager]::RmStartSession([ref]$sessionHandle,0,$sessionKey)
if ($result -ne 0) {
    throw "RmStartSession failed. Error: $result"
}

try {

    $result = [RestartManager]::RmRegisterResources(
        $sessionHandle,
        1,
        @($TargetFile),
        0,
        [IntPtr]::Zero,
        0,
        $null
    )

    if ($result -ne 0) {
        throw "RmRegisterResources failed. Error: $result"
    }

    $needed = 0
    $count = 0
    $rebootReasons = 0

    [void][RestartManager]::RmGetList(
        $sessionHandle,
        [ref]$needed,
        [ref]$count,
        $null,
        [ref]$rebootReasons
    )

    if ($needed -eq 0) {

@"
=================================================
EnumLockedFiles
=================================================
Timestamp : $(Get-Date)
TargetFile: $TargetFile

No locking processes identified.
"@ | Out-File $LogFile -Force

        Write-Host "Results written to $LogFile"
        return
    }

    $count = $needed
    $processInfo = New-Object 'RestartManager+RM_PROCESS_INFO[]' $count

    [void][RestartManager]::RmGetList(
        $sessionHandle,
        [ref]$needed,
        [ref]$count,
        $processInfo,
        [ref]$rebootReasons
    )

    $output = foreach ($proc in $processInfo) {

        $ProcessId = $proc.Process.dwProcessId

        try {

            $p = Get-Process -Id $ProcessId -ErrorAction Stop

            if ($ExcludedProcessNames -contains $p.ProcessName.ToLower()) {
                continue
            }

            $owner = 'Unknown'

            try {
                $cim = Get-CimInstance Win32_Process -Filter "ProcessId=$ProcessId"
                $ownerInfo = Invoke-CimMethod -InputObject $cim -MethodName GetOwner
                if ($ownerInfo.User) {
                    $owner = $ownerInfo.User
                }
            }
            catch {}

            [PSCustomObject]@{
                PID         = $ProcessId
                ProcessName = $p.ProcessName
                Owner       = $owner
                Path        = $p.Path
                StartTime   = $p.StartTime
                TargetFile  = $TargetFile
            }
        }
        catch {
            [PSCustomObject]@{
                PID         = $ProcessId
                ProcessName = 'Exited'
                Owner       = 'Unknown'
                Path        = ''
                StartTime   = $null
                TargetFile  = $TargetFile
            }
        }
    }

    $output = $output | Sort-Object PID

    $output | Format-Table -AutoSize

@"
=================================================
EnumLockedFiles
=================================================
Timestamp : $(Get-Date)
TargetFile: $TargetFile

"@ | Out-File $LogFile -Force

    $output |
        Format-Table -AutoSize |
        Out-String -Width 4096 |
        Out-File $LogFile -Append

    Write-Host ""
    Write-Host "Results written to $LogFile"
}
finally {
    [RestartManager]::RmEndSession($sessionHandle) | Out-Null
}
