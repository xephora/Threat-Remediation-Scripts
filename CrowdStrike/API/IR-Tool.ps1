using namespace System.Management.Automation.Host
Import-Module -Name psfalcon
Request-FalconToken -ClientId <ClientID> -ClientSecret <ClientSecret>

Function intro {
    <#
            .SYNOPSIS
                CrowdStrike API Script (Prototype).
    
            .DESCRIPTION
                The script will assist Cyber Defenders with a portable way to interface with CrowdStrike.  This an experimental script, it is recommended to use PowerShell ISE running with administrator rights and I use the CyberDefense-CommandQueued feature of the script.  There's a friendly interactive CLI menu for beginners.
            
            .WARNING
            For this script to work, the agent must enter in their Falcon Client Id and Client Secret at the top section of the script.
            
            For Example:
            
            Request-FalconToken -ClientId d3adb33fd3adb33fd3adb33f -ClientSecret d3adb33fd3adb33fd3adb33fd3adb33f
        #>
}
    
Function help {
    "
    If you are experiencing any errors with the script, make sure that PSFalcon module is installed.
    
    You can type 'install' to install the PSFalcon module for powershell
    
    Note: For this script to work fully, you will need to run this script as administrator.
    NoteII: You may also need to modify your execution policy to use the script.
    "
}

function install {
    Install-Module -Name PSFalcon -Scope CurrentUser
}
function CyberDefense-Investigate-HostLookup {
    $hostn = Read-Host 'Enter Hostname'
    Get-FalconHost -Detailed -Filter "hostname:'$hostn'" | format-List device_id, hostname, local_ip, mac_address, os_version, external_ip, last_seen, first_seen, agent_version, status
}

Function CyberDefense-Command {
    $hostname = Read-Host 'Hostname: '
    $host_id = Get-FalconHost -Detailed -Filter "hostname:'$hostname'" | Select-Object device_id
    $a = 0
    $max = 100

    DO 
    {
        $rtrcommand = Read-Host "Type Command:>  "
        $detectOPT = $rtrcommand.split(" ")
        $cmd = @("ps","ls","cp","encrypt","get","kill","map","memdump","mkdir","mv","reg query","reg delete","reg load","reg set","reg unload","restart","rm","shutdown","umount","unmap","update history","update install","update list","update install","xmemdump","zip")        

        foreach ($i in $cmd) {
            if ($detectOPT[0] -eq $i) {
                $cmdNarg = $rtrcommand.replace("${i} ", "${i}??").split("??")
                Invoke-FalconRTR -Command "$($cmdNarg[0])" -Arguments "$($cmdNarg[2])" -HostIds $($host_id.device_id)
            }
        }
        if ($rtrcommand -eq "exit") {exit}
    } While ($a -le $max)
}

Function CyberDefense-CommandQueued {
    $hostname = Read-Host 'Hostname: '
    $host_id = Get-FalconHost -Detailed -Filter "hostname:'$hostname'" | Select-Object device_id
    $a = 0
    $max = 100

    DO 
    {
        $rtrcommand = Read-Host "Type Command:>  "
        $detectOPT = $rtrcommand.split(" ")
        $cmd = @("ps","ls","cp","encrypt","get","kill","map","memdump","mkdir","mv","reg query","reg delete","reg load","reg set","reg unload","restart","rm","shutdown","umount","unmap","update history","update install","update list","update install","xmemdump","zip","mount","put")        

        foreach ($i in $cmd) {
            if ($detectOPT[0] -eq $i) {
                $cmdNarg = $rtrcommand.replace("${i} ", "${i}??").split("??")
                Invoke-FalconRTR -Command "$($cmdNarg[0])" -Arguments "$($cmdNarg[2])" -HostIds $($host_id.device_id) -QueueOffline $true
            }
        }
        if ($rtrcommand -eq "exit") {exit}
    } While ($a -le $max)
}

Function CyberDefense-Command-Advanced {
    $a = 0
    $max = 100

    $hostname = Read-Host 'Hostname: '
    $host_id = Get-FalconHost -Detailed -Filter "hostname:'$hostname'" | Select-Object device_id

    "
    ========================================================================================================================================================================================
    Usage: 
    @> ps
    args: 
    @> reg query
    args: HKU
    @> cd
    args: C:\
    @> rm
    args: -force C:\users\profile\FolderName

    Command List:

    cat | cd | clear | cp | csrutil | encrypt | env | eventlog | filehash | get | getsid | 
    history | ifconfig | ipconfig | kill | ls | map | memdump | mkdir | mount | mv | 
    netstat | ps | put | reg | query | reg | set | reg | delete | reg | load | reg | 
    unload | restart | rm | run | runscript | shutdown | umount | update | list | update | 
    history | update | install | update | query | unmap | users | xmemdump | zip

    To exit type 'exit'
    ========================================================================================================================================================================================
    "
    DO 
    {
        $CD_Input = Read-Host "command:> "
        $CD_Arg = Read-Host "argument: "
        $a++

        Invoke-FalconRTR -Command $CD_Input -Arguments $CD_arg -HostIds $host_id.device_id | Select-Object -ExpandProperty stdout | Format-Table -AutoSize

        if ($CD_Input -eq "exit") {break}
    } While ($a -le $max)
    "You have exited the Console"
}

Function CyberDefense-Investigate-ShowUsers {
    $hostn = Read-Host "Hostname: "
    $host_id = Get-FalconHost -Detailed -Filter "hostname:'$hostn'" | Select-Object device_id
    $ostype = Read-Host "Choose operation system of target host: type 'win' for Windows 'mac' for MAC or 'lin' for linux
    :> "
    if($ostype -eq "win") {
        Invoke-FalconRTR -Command ls -Arguments C:\users -HostIds $host_id.device_id | Select-Object -ExpandProperty stdout | Format-Table -AutoSize
    } elseif($ostype -eq "mac") {
        Invoke-FalconRTR -Command ls -Arguments /users -HostIds $host_id.device_id | Select-Object -ExpandProperty stdout | Format-Table -AutoSize
    } elseif($ostype -eq "lin") {
        Invoke-FalconRTR -Command ls -Arguments /home -HostIds $host_id.device_id | Select-Object -ExpandProperty stdout | Format-Table -AutoSize
    } else {
        "You have incorrectly  typed the os. Please type win for windows or mac or lin for linux"
    }
}

Function Main {
    "
    1 Retrieve host information
    2 Connect to a host using RTR
    3 Retrieve usernames from host
    
    Type 'help' for help menu or type 'exit' to exit the script
    "
    $option = Read-Host "Choose Option:> "
    switch ($option) {
        1 {
            CyberDefense-Investigate-HostLookup
        }
        2 {
            $option = Read-Host "
            1 Use Basic RTR Console
            2 Use Advanced RTR Console
            3 Use Basic RTR Console Queued Mode (Allows you to queue commands and execute once the host returns online)
            :> "
            if ($option -eq 1) {
                CyberDefense-Command
            } elseif ($option -eq 2) {
                CyberDefense-Command-Advanced
            } elseif ($option -eq 3) {
                CyberDefense-CommandQueued
            } else {exit}
        }
        3 {
            CyberDefense-Investigate-ShowUsers
        }
        "help" {help}
        default {exit}
    }
}

Main
