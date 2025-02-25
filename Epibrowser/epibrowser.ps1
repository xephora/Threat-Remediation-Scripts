#Epibrowser removal script
#Based on Onelaunch removal script:
#https://github.com/xephora/Threat-Remediation-Scripts/blob/main/OneLaunch/OneLaunch-Remediation-Script.ps1

# find running processes with "epibrowser" in them
$valid_path = "C:\Users\*\AppData\Local\EPISoftware\*"
$process_names = @("epibrowser")
    foreach ($proc in $process_names){
	$OL_processes = Get-Process | Where-Object { $_.Name -like $proc }
	if ($OL_processes.Count -eq 0){
		Write-Output "No $proc processes were found."
	}else {
		write-output "The following processes contained $proc and file paths will be checked: $OL_processes"
		foreach ($process in $OL_processes){
			$path = $process.Path
			if ($path -like $valid_path){
				Stop-Process $process -Force
				Write-Output "$proc process file path matches and has been stopped."
			}else {
				Write-Output "$proc file path doesn't match and process was not stopped."
			}
		}
	}
}

Start-Sleep -Seconds 2
$file_paths = @("\AppData\Local\EPISoftware\",
"\appdata\Roaming\Microsoft\Windows\Start Menu\Programs\EpiBrowser.lnk"
"\appdata\Roaming\Microsoft\Windows\Start Menu\Programs\EpiStart.lnk"
)

# Iterate through users for Epibrowser-related directories and deletes them
foreach ($folder in (Get-ChildItem C:\Users)) {
	foreach ($fpath in $file_paths) {
		$path = Join-Path -Path $folder.FullName -ChildPath $fpath
		# Debugging output
		Write-Output "Checking path: $path"
		if (Test-Path $path) {
			Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
			if (-not (Test-Path $path)) {
				Write-Output "$path has been deleted."
			} else {
				Write-Output "$path could not be deleted."
			}
		} else {
			Write-Output "$path does not exist."
		}
	}
}

# Deletes system32 task
$file_paths = @("EpiBrowserStartup*")
foreach ($folder in (Get-item C:\Windows\system32\tasks\)) {
	foreach ($fpath in $file_paths) {
		$path = Join-Path -Path $folder.FullName -ChildPath $fpath
		# Debugging output
		Write-Output "Checking path: $path"
		if (Test-Path $path) {
			Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
			if (-not (Test-Path $path)) {
				Write-Output "$path has been deleted."
			} else {
				Write-Output "$path could not be deleted."
			}
		} else {
			Write-Output "$path does not exist."
		}
	}
}

$reg_paths = @("\Software\EPISoftware")

# iterate through users for epibrowser related registry keys and removes them
foreach ($registry_hive in (get-childitem registry::hkey_users)) {
	foreach ($regpath in $reg_paths){
		$path = $registry_hive.pspath + $regpath
		if (test-path $path) {
			Remove-item -Path $path -Recurse -Force
			write-output "$path has been removed."
		}
	}
}

$reg_properties = @("EpiBrowserStartup", "EpiBrowserUpdate")
foreach($registry_hive in (get-childitem registry::hkey_users)){
	foreach ($property in $reg_properties){
		$path = $registry_hive.pspath + "\software\microsoft\windows\currentversion\run"
		if (test-path $path){
			$reg_key = Get-Item $path
			$prop_value = $reg_key.GetValueNames() | Where-Object { $_ -like $property }
			if ($prop_value){
				Remove-ItemProperty $path $prop_value
				Write-output "$path\$prop_value registry property value has been removed."
			}
		}
	}
}

# Further removing traces from user registry
$keys = @(
"\Software\Classes\EPIHTML*",
"\Software\Classes\EPIPDF*",
"\Software\Clients\StartMenuInternet\EpiBrowser*",
"\Software\Microsoft\Windows\CurrentVersion\App Paths\epibrowser.exe",
"\Software\Microsoft\Windows\CurrentVersion\App Paths\epibrowser.exe",
"\Software\Microsoft\Windows\CurrentVersion\Uninstall\EPISoftware EpiBrowser"
)
foreach($registry_hive in (get-childitem registry::hkey_users)){
	foreach ($key in $keys){
		$path = $registry_hive.pspath + $key
		if (test-path $path){
			$reg_key = Get-Item $path
			$prop_value = $reg_key.PSChildName | Where-Object { $_ -like $key.Split('\')[-1] }
			if ($prop_value){
				Remove-Item $path -Force -Recurse
				Write-output "$path registry key has been removed."
			}
		}
	}
}

$keys = @(
"\Software\Classes\.shtml\OpenWithProgids\",
"\Software\Classes\.htm\OpenWithProgids\"
)
$reg_properties = @("EPIHTML*")
foreach($registry_hive in (get-childitem registry::hkey_users)){
	foreach($key in $keys){
		foreach($reg_property in $reg_properties){
			$path = $registry_hive.pspath + $key
			if (test-path $path){
				$reg_key = Get-Item $path
				$prop_value = $reg_key.Property | Where-Object { $_ -like $reg_property }
				if ($prop_value){
					Remove-ItemProperty $path $prop_value
					Write-output "$path\$prop_value registry property value has been removed."
				}
			}
		}
	}
}
# Removing traces from Local Machine registry
$reg_properties = @(
"\Software\Microsoft\MediaPlayer\ShimInclusionList\epibrowser.exe",
"\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\EpiBrowserStartup*"
)
$registry_hive = Get-Item registry::HKEY_LOCAL_MACHINE
foreach($property in $reg_properties){
	$path = $registry_hive.pspath
	if (test-path $path){
		$reg_key = Get-Item $path
		$prop_value = $reg_key.GetValueNames() | Where-Object { $_ -like $property }
		if ($prop_value){
			Remove-ItemProperty $path $prop_value
			Write-output "$path\$prop_value registry property value has been removed."
			}
		}
}

$schtasknames = @("EpiBrowserStartup*")
$c = 0

# find epibrowser related scheduled tasks and unregister them
foreach ($taskname in $schtasknames){
	$tasks = get-scheduledtask -taskname $taskname -ErrorAction SilentlyContinue
	foreach ($task in $tasks){
		$c++
		Unregister-ScheduledTask -TaskName $task.taskname -Confirm:$false
		Write-Output "Scheduled task '$task' has been removed."
	}
}

if ($c -eq 0){
	Write-Output "No Epibrowser scheduled tasks were found."
}