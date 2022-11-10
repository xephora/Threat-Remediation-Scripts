param (
    [Parameter(Mandatory)]
    [string] $hostname
)
Import-Module -Name psfalcon
Request-FalconToken -ClientId EnterClientIDHere -ClientSecret EnterClientSecretHere

function help {
    "
    [!] Usage:
    .\CSSession.ps1 Hostname
    .\CSSession.ps1 help (Usage Example)
    .\CSSession.ps1 install (Installs PSFalcon Module)
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

        DO 
        {
            $rtrcommand = Read-Host "Type Command:>  "
            $detectOPT = $rtrcommand.split(" ")
            $cmd = @("ps","ls","cp","encrypt","get","kill","map","memdump","mkdir","mv","reg query","reg delete","reg load","reg set","reg unload","restart","rm","shutdown","umount","unmap","update history","update install","update list","update install","xmemdump","zip", "cat","ipconfig","ifconfig")        

            foreach ($i in $cmd) {
                if ($detectOPT[0] -eq $i) {
                    $cmdNarg = $rtrcommand.replace("${i} ", "${i}??").split("??")
                    $result = Invoke-FalconRTR -Command "$($cmdNarg[0])" -Arguments "$($cmdNarg[2])" -HostIds $($host_id.device_id) -QueueOffline $true
                    write-host $result
                }
            }
            if ($rtrcommand -eq "exit") {exit}
        } While ($a -le $max)}
}

$Session = New-Object CSSession
$Session.hostname = $hostname
$Session.Connect()
