# CrowdStrike API script (queued feature)

### The queued feature allows you to run a script on a host that is offline.  Once the host appears online, the script will run.

### Requirements:

- This script requires a CrowdStrike CloudFile name.  Example: `-CloudFile='SomeScriptName.ps1'`
- You must also configure your API Key + ClientID. Reference: `Request-FalconToken -ClientId <CID> -ClientSecret <SECRET>`
- Lastly, ensure you have the correct API permissions in order for this script to run.

# CSSession

CSSession is a tool that allows you to quickly start a interactive shell via Real-Time-Response API.  In order for CSSession to work, you must modify the clientid and secret.

```
Usage: CSSession.ps1 hostname01
Type Command:>  :  ps

      WorkingMemory(kb)   CPU(s) HandleCount Path
----                       -- ---------             -----------------   ------ ----------- ----
Adobe CEF Helper         9588 11/9/2022 10:31:28 AM           115,828    22.09         553 C:\Program Files\Common Files\Adobe\Adobe Desktop
                                                                                           Common\HEX\Adobe CEF Helper.exe
Adobe CEF Helper        15768 11/9/2022 10:31:17 AM            72,664    20.84         450 C:\Program Files\Common Files\Adobe\Adobe Desktop
                                                                                           Common\HEX\Adobe CEF Helper.exe
Adobe Desktop Service   15672 11/9/2022 10:31:17 AM           224,364    73.61         996 C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop    
                                                                                           Common\ADS\Adobe Desktop Service.exe
AdobeIPCBroker          14796 11/9/2022 10:31:09 AM            17,996    14.75         280 C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop    
                                                                                           Common\IPCBox\AdobeIPCBroker.exe
AdobeUpdateService       4640 11/9/2022 1:06:12 AM             10,972     0.56         219 C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop    
                                                                                           Common\ElevationManager\AdobeUpdateService.exe
AGMService               4668 11/9/2022 1:06:12 AM             13,800     0.61         248 C:\Program Files (x86)\Common
                                                                                           Files\Adobe\AdobeGCClient\AGMService.exe
AGSService               4740 11/9/2022 1:06:12 AM             13,740     1.89         240 C:\Program Files (x86)\Common
                                                                                           Files\Adobe\AdobeGCClient\AGSService.exe
armsvc                   4628 11/9/2022 1:06:12 AM              7,296     0.19         138 C:\Program Files (x86)\Common
                                                                                           Files\Adobe\ARM\1.0\armsvc.exe
[..TRUCATION..]
```

### Updates

- Updated and optimized code for CSSession.
