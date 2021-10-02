$username = "USERNAME_HERE"

Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process iexplore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

rm "C:\users\$username\Wavesor Software" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\appdata\local\WaveBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\appdata\local\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\users\$username\downloads\Wave Browser*.exe" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError

$tasks = Get-ScheduledTask -TaskName *Wave* | Select-Object -ExpandProperty TaskName
foreach ($i in $tasks) {
	Unregister-ScheduledTask -TaskName $i -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
}

Remove-Item -Path HKCU:\Software\WaveBrowser -Force -ErrorAction SilentlyContinue
Remove-Item -Path HKCU:\Software\Wavesor -Force -ErrorAction SilentlyContinue
Remove-Item -Path HKCU:\Software\WebNavigatorBrowser -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU\Software\Microsoft\Windows\CurrentVersion\Run.Wavesor SWUpdater" -Force -ErrorAction SilentlyContinue
