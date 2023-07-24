param (
    [Parameter(Mandatory)]
    [string] $hostname
)
Import-Module -Name psfalcon
Request-FalconToken -ClientId <CID> -ClientSecret <SECRET>

function help {
    "
    [!] Usage:
    .\CSSession.ps1 Hostname   (Connects to a host using Real-Time-Response via API)
    .\CSSession.ps1 help       (Usage Example)
    .\CSSession.ps1 install    (Installs PSFalcon Module)
    "
}
if ($hostname -eq "help") {
    help
    exit
}
function install {
    Install-Module -Name PSFalcon -Scope CurrentUser
}
if ($hostname -eq "install") {
    install
    exit
}

Class CSSession {
    [string] $hostname = $null
    Connect () {
        $host_id = Get-FalconHost -Detailed -Filter "hostname:'$($this.hostname)'" | Select-Object device_id
        $a = 0
        $max = 100
        if (!$host_id){ Write-Host "[!] Failed to retrieve host id. Host likely doesn't exist in CrowdStrike."; return }
        DO 
        {
            $rtrcommand = Read-Host "Type Command:>  "
            if ($rtrcommand -eq "exit") {exit}
            $cmds = @("ps","ls","cp","encrypt","get","kill","map","memdump","mkdir","mv","reg query","reg delete","reg load","reg set","reg unload","restart","rm","shutdown","umount","unmap","update history","update install","update list","update install","xmemdump","zip", "cat","ipconfig","ifconfig","filehash")
            $match = [RegEx]::Match($rtrcommand, "^(reg query|reg delete|reg load|reg set|reg unload|update history|update install|update list|update install|\w+)\s*(.*)")
            $command = $match.Groups[1].Value
            $arguments = $match.Groups[2].Value.Trim()
            foreach ($cmd in $cmds) {
                if ($command -eq $cmd) {
                    $result = Invoke-FalconRTR -Command "$cmd" -Arguments "$arguments" -HostIds $($host_id.device_id) -QueueOffline $true
                    write-host $result
                }
            }
        } While ($a -le $max)}
}

$Session = New-Object CSSession
$Session.hostname = $hostname
$Session.Connect()
