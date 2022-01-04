# Removal
Get-Process DSOne -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process DSOneWD -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
sleep 2

rm "C:\windows\system32\tasks\DSOne Agent" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
rm "C:\Program Files (x86)\Driver Support One" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\DSOne Agent" -Recurse -ErrorAction SilentlyContinue

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($i in $user_list) {
    if ($i -notlike "*Public*") {
        rm "C:\users\$i\downloads\DSOne*.exe" -Force -ErrorAction SilentlyContinue -ErrorVariable DirectoryError	
    }
}

# Check removal

$result = test-path -Path "C:\windows\system32\tasks\DSOne Agent"
if ($result -eq "True") {
	"DSOne Agent wasn't removed => on C:\windows\system32\tasks\DSOne Agent"
}

$result = test-path -Path "C:\Program Files (x86)\Driver Support One"
if ($result -eq "True") {
	"DSOne Agent wasn't removed => on C:\Program Files (x86)\Driver Support One"
}

$result = test-path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\DSOne Agent"
if ($result -eq "True") {
	"DSOne Agent wasn't removed => on HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\DSOne Agent"
}
