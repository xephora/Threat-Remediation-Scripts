# CrowdStrike API script (queued feature)

### The queued feature allows you to run a script on a host that is offline.  Once the host appears online, the script will run.

### Requirements:

- This script requires a CrowdStrike CloudFile name.  Example: `-CloudFile='SomeScriptName.ps1'`
- You must also configure your API Key + ClientID. Reference: `Request-FalconToken -ClientId <CID> -ClientSecret <SECRET>`
- Lastly, ensure you have the correct API permissions in order for this script to run.
