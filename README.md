# Introduction

Over the course of two years, I have developed a number of scripts to assist me with my investigations and remediation efforts.  I figured, why not share them to the public, in hopes it helps you.

# How do these scripts work? 

The scripts I developed are intended to work with Crowdstrike Endpoint Detection and Response (EDR).  Essentially cloud scripts to quickly remediate devices remotely with a single click of a button.

# Why create these scripts?

The purpose of my scripts is to assist a SOC or Incident Response Analyst with their investigation. Some scripts assist with remediation of a particular unwanted software/adware. Other scripts assist with investigating a particular system by username to provide more visibility.

# Table of content

### Manual Cloud Scripts

- [WinInspect](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Manual_Scripts/Investigation/WinInspect_v3.ps1) - WinInspect is a light-weight tool to assist an analyst with providing more visibility into a Windows system based on a target username.
- [MACInspect](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Manual_Scripts/Investigation/MACInspect.sh) - MACInspect is a light-weight tool to assist an analyst with providing more visibility into a MAC system based on a target username.
- [LinInspect](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Manual_Scripts/Investigation/LinInspect.sh) - LinInspect is a light-weight tool to assist an analyst with providing more visibility into a Linux system based on a target username.
- [EnumChromeExt](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Manual_Scripts/Investigation/Win-EnumChromeExt_v2.ps1) - EnumChromeExt retrieves Chrome Extensions and automatically attempts to detect the name.
- [Win-PortScanner](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Manual_Scripts/Investigation/Win-PortScanner.ps1) - Win-PortScanner is an extremely light port scanner.
- [ScanDll](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Manual_Scripts/Investigation/ScanDll.ps1) - ScanDll is tool to help search processes for a particular dynamic-link library.

### Crowdstrike API Scripts

- [CSSession](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/CrowdStrike/API/CSSession.ps1) - CSSession is a CrowdStrike API script that allows you to connect via Real-Time-Response by entering a target hostname as an argument.  You must have the appropriate api permissions and ensure your clientid / secret is correct to use this script.
- [CrowdStrike-API-queued-script](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/CrowdStrike/API/CrowdStrike-API-queued-script.ps1) - CrowdStrike API Queued script allows you to queue a cloud script of your choice to a target host.  You must have the appropriate api permissions and clientid / secret is correct to use this script.

### Crowdstrike Remediation Scripts

The following library contains a list of common unwanted software/adware that are seen in the wild.  If you see a particular software you would like to remediate, feel free to download and use it in your environment.

- [123Movies](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/123Movies)
- [39bar](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/39bar)
- [AppMaster](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/AppMaster)
- [AppRun](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/AppRun)
- [AskPartnerNetwork](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/AskPartnerNetwork)
- [BBSK(SecureBrowser)](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/BBSK(SecureBrowser))
- [Bloom](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Bloom)
- [BrightTramp](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/BrightTramp)
- [BrowserAssistant](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/BrowserAssistant)
- [ByteFence](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/ByteFence)
- [Cash](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Cash)
- [Clear](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Clear)
- [Clearbar](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Clearbar)
- [DSOne Agent](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/DSOne%20Agent)
- [DriverSupportAOsvc](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/DriverSupportAOsvc)
- [ElevenClock](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/ElevenClock)
- [Energy](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Energy)
- [Gallery](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Gallery)
- [GameCenter](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/GameCenter)
- [Healthy](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Healthy)
- [IBuddy](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/IBuddy)
- [LiteBrowser](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/LiteBrowser)
- [OneLaunch](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/OneLaunch)
- [PCAcceleratePro](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/PCAcceleratePro)
- [PCAppStore](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/PCAppStore)
- [PCHelpSoftDriverUpdater](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/PCHelpSoftDriverUpdater)
- [PC_Cleaner](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/PC_Cleaner)
- [Prime](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Prime)
- [SlimCleaner](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/SlimCleaner)
- [Strength](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Strength)
- [Taskbarsystem](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Taskbarsystem)
- [Tone](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Tone)
- [Walliant](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Walliant)
- [WaveBrowser](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/WaveBrowser)
- [WebDiscoverBrowser](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/WebDiscoverBrowser)
- [Wellness](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/Wellness)
- [XMRig](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/XMRig)
- [flbmusic](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/flbmusic)
- [streamlink-twitch-gui](https://github.com/xephora/Threat-Remediation-Scripts/tree/main/streamlink-twitch-gui)

> Do you find my work helpful and want to show your support? Feel free to add me on [Twitter](https://twitter.com/x3ph1).

> Any issues with a script, please feel free to report it as an [issue](https://github.com/xephora/Threat-Remediation-Scripts/issues).
