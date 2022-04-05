# This script requires a CrowdStrike CloudFile Script name below.  You must also configure your API Key + ClientID below.  Lastly, ensure you have the correct API permissions in order for this script to run.

using namespace System.Management.Automation.Host
Import-Module -Name psfalcon

Request-FalconToken -ClientId <CID> -ClientSecret <SECRET>


$hostn = Read-Host "Hostname: "
$host_id = Get-FalconHost -Detailed -Filter "hostname:'$hostn'" | Select-Object device_id
Invoke-FalconRTR -Command runscript -Arguments "-CloudFile='<CloudScriptName>'" -HostIds $host_id.device_id -QueueOffline $true
