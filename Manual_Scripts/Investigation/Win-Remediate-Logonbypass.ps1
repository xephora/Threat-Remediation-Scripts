# This script checks if any of the Windows utility binaries have been replaced with cmd.exe and takes ownership before removing.
# For more information, you can refer to https://swisskyrepo.github.io/InternalAllTheThings/redteam/persistence/windows-persistence/#binary-replacement.
$paths = @("C:\Windows\System32\sethc.exe"
"C:\Windows\System32\utilman.exe"
"C:\Windows\System32\osk.exe"
"C:\Windows\System32\Magnify.exe"
"C:\Windows\System32\Narrator.exe"
"C:\Windows\System32\DisplaySwitch.exe"
"C:\Windows\System32\AtBroker.exe")

foreach ($path  in $paths){
	if (test-path $path) {
		$fileVersionInfo = Get-ItemProperty $path
		$fileVersionInfo.VersionInfo | % { if ($_.OriginalFilename -like "*cmd.exe*") { "Found improper bin: $_.filename"; takeown /f $path; icacls $path /grant Administrators:F; icacls $path /grant SYSTEM:F ; rm $path}}
		if(-not(test-path $path)) {
			"Successfully deleted $path."
		}
	}
}
