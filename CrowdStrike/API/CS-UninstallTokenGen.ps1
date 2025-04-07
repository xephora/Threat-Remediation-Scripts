<#
.SYNOPSIS
    Obtain Falcon uninstall tokens for one or more hosts and export them to CSV.

.DESCRIPTION
    - Use -Hostname to supply one or more hostnames directly.
    - Use -Hostfile  to supply a .csv or .txt file that contains hostnames.
      The CSV must have a column named 'hostname'.

.PARAMETER Hostname
    One or more hostnames, e.g. -Hostname HOSTNAME,HOSTNAME2

.PARAMETER Hostfile
    Path to a text file (one hostname per line) or CSV with a 'hostname' column.

.EXAMPLE
    PS> .\CrowdStrikeUninstall.ps1 -Hostname hostname

.EXAMPLE
    PS> .\CrowdStrikeUninstall.ps1 -Hostfile .\hosts.csv
#>

# After reviewing the source code for psfalcon sensor script, I was able to reconstruct a working poc designed for external tools such as Microsoft Intunes. 
# https://github.com/CrowdStrike/psfalcon/blob/f0b3a683b0e1d17857b1785b5e7da06097d7714d/public/psf-sensors.ps1#L323
# Requirements: Refer to PSFalcon's wiki https://github.com/CrowdStrike/psfalcon/wiki/Uninstall-FalconSensor
param(
    [Parameter(Mandatory, ParameterSetName='ByName', Position=0)]
    [Alias('Hostname')]
    [string[]] $ComputerName,

    [Parameter(Mandatory, ParameterSetName='ByFile', Position=1)]
    [Alias('Hostfile')]
    [string]   $HostnameFile,

    [Parameter(ParameterSetName = 'Help')]
    [Alias('h','?')]
    [switch] $Help
)

if ($Help) {
    Get-Help -Detailed $MyInvocation.MyCommand.Path
    return
}

switch ($PSCmdlet.ParameterSetName) {
    'ByName' { $Hostnames = $ComputerName }

    'ByFile' {
        if (-not (Test-Path $HostnameFile)) {
            throw "File '$HostnameFile' not found."
        }
        $ext = [IO.Path]::GetExtension($HostnameFile).ToLower()
        switch ($ext) {
            '.csv' {
                $hdr = (Import-Csv $HostnameFile | Select-Object -First 1).PSObject.Properties.Name
                if ($hdr -notcontains 'hostname') {
                    throw "CSV lacks a 'hostname' column."
                }
                $Hostnames = Import-Csv $HostnameFile | Select-Object -ExpandProperty hostname
            }
            '.txt' {
                $Hostnames = Get-Content $HostnameFile | Where-Object { $_.Trim() }
            }
            default {
                throw "Unsupported file type '$ext'. Use .csv or .txt."
            }
        }
    }
}

if (-not $Hostnames) { throw 'No hostnames supplied.' }

Import-Module -Name psfalcon
Request-FalconToken -ClientId <CID> -ClientSecret <SECRET>

function Get-UninstallToken {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Id
    )
    [string[]]$Select = 'cid','device_id','platform_name','device_policies'
    $HostList = Get-FalconHost -Id $Id | Select-Object $Select

    if ($HostList.platform_name -notmatch '^(Windows|Linux)$') {
        throw 'Only Windows and Linux hosts are currently supported for uninstallation using PSFalcon.'
    }

    [string]$IdValue = switch ($HostList.device_policies.sensor_update.uninstall_protection) {
            'ENABLED' { $HostList.device_id }
            'MAINTENANCE_MODE' { 'MAINTENANCE' }
    }

    if ($IdValue) {
            [string]$Token = ($IdValue | Get-FalconUninstallToken -AuditMessage ("Uninstall-FalconSensor [$((Show-FalconModule).UserAgent)]")).uninstall_token
    }

    return $Token
}

function Get-Hostname {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Id
    )
    if (!$id) {
        throw "unable to retrieve hostname. No Id found."
    }
    return (Get-FalconHost -Id $Id | Select-Object hostname).hostname
}

$IdList = @()
foreach ($name in $Hostnames) {
    $IdList += Get-FalconHost -Detailed -Filter "hostname:'$name'" |
               Select-Object -Expand device_id
}
if (-not $IdList) { throw 'No device IDs found.' }

if (!$IdList) {
    throw "No Id found."
}

$Tokens = @{}
foreach ($Id in $IdList) {
    $token    = Get-UninstallToken $Id
    $hostname = Get-Hostname      $Id
    $Tokens[$hostname] = $token
    Write-Host "$hostname $token"
}

if (-not $Tokens.Count) { throw 'No tokens generated.' }

$Tokens.GetEnumerator() | Export-Csv '.\token_list.csv' -NoTypeInformation
Write-Host 'Maintenance tokens dumped to token_list.csv'
