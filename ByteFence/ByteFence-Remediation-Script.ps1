$service = Get-Service -Name 'ByteFenceService' -ErrorAction SilentlyContinue
if ($service) { $service | Stop-Service -Force -ErrorAction SilentlyContinue }

if ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -eq 0) {
    Remove-Service -Name ByteFenceService -Force -ErrorAction SilentlyContinue
}

$processes = @( 'ByteFenceService', 'rtop_bg', 'rtop_svc' )
foreach ($process in $processes) {
    $proc = Get-Process $process -ErrorAction SilentlyContinue
    if ($proc) { $proc | Stop-Process -Force -ErrorAction SilentlyContinue }
}

Start-Sleep -Seconds 2
$paths = @( 
    "C:\Program Files\ByteFence",
    "C:\ProgramData\ByteFence",
    "C:\windows\system32\tasks\ByteFence",
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ByteFence",
    "Registry::HKEY_LOCAL_MACHINE\Software\ByteFence"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $path) {
            "Script failed to remove $path"
        }
    }
}
