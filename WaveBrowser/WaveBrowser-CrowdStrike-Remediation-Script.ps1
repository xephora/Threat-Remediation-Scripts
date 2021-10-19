$username = "USERNAME_HERE"
$sid_id = "SID_HERE"

Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process iexplore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process SWUpdater -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

rm "C:\users\$username\Wavesor Software" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\appdata\local\WaveBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\appdata\local\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\downloads\Wave Browser*.exe" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError

$tasks = Get-ScheduledTask -TaskName *Wave* | Select-Object -ExpandProperty TaskName
foreach ($i in $tasks) {
	Unregister-ScheduledTask -TaskName $i -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
}

Remove-Item -Path Registry::HKU\$sid_id\Software\WaveBrowser -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path Registry::HKU\$sid_id\Software\Wavesor -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path Registry::HKU\$sid_id\Software\WebNavigatorBrowser -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKU\$sid_id\Software\Microsoft\Windows\CurrentVersion\Run.Wavesor SWUpdater" -Recurse -ErrorAction SilentlyContinue
