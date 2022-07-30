<# 
Description:
Scans all processes for a particular module.

How Does the scanner work?

Entered an example Dll: $dllkeyword = "FLTLIB.DLL"

Scan Results:
.\ScanDll.ps1
[+] Scanning Dlls..
[+] Discovered Dependency: C:\WINDOWS\SYSTEM32\FLTLIB.DLL on Process: explorer
[+] Discovered Dependency: C:\WINDOWS\SYSTEM32\FLTLIB.DLL on Process: gamingservices
[+] Discovered Dependency: C:\WINDOWS\SYSTEM32\FLTLIB.DLL C:\WINDOWS\SYSTEM32\FLTLIB.DLL on Process: svchost
#>

$dllkeyword = "<ENTERDLLNAMEHERE>"
$procs = Get-Process | select ProcessName
$checkrole = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$checkrole = $checkrole.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($checkrole -eq $false) {
    "[INFO] Running Scanner with limited privileges. This will restrict the scan results. Please run as administrator."
}
"[+] Scanning Dlls.."
foreach($proc in $procs) {
    if ($dllkeyword) {
        if (![string]$proc.ProcessName) {
            continue   
        }
        $x = Get-Process $proc.ProcessName | select ProcessName -expand Modules -ea 0 | where { $_.FileName -like "*$($dllkeyword)"}
        $procId = Get-Process $proc.ProcessName | select Id
        $FileName = [string]$x.FileName
        $isEmpty = [string]::IsNullOrEmpty($FileName)
        $ProcName = [string]$proc.ProcessName
        if (!$isEmpty) {
            "[+] Discovered Dependency: $FileName on Process: $ProcName on Process ID: $($procId.Id)"
        }
    } else { "Incorrect Input"; exit }
}


