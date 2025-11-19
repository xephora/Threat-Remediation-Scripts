$process = Get-Process "Easy2Convert" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue    
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($username in $user_list) {
    if ($username -notlike "*Public*") {
        $paths = @(
            "C:\Users\$username\AppData\Local\Easy2Convert"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    "Easy2Convert Removal Unsuccessful => $path"
                }
            }
        }

        $installers = @(Get-ChildItem "C:\Users\$username\Downloads" -Filter "Easy2Convert*.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
        foreach ($install in $installers) {
            if (Test-Path $install) {
                Remove-Item $install -Force -ErrorAction SilentlyContinue
                if (Test-Path $install) {
                    "Easy2Convert Installer Removal Unsuccessful => $install"
                }
            }
        }
    }
}

$tasks = Get-ScheduledTask -TaskName "*Easy2ConvertTask*" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty TaskName
foreach ($task in $tasks) {
    Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
}

$taskPaths = @(
    "C:\Windows\System32\Tasks\Easy2ConvertTask",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Easy2ConvertTask"
)
foreach ($taskPath in $taskPaths) {
    if (Test-Path -Path $taskPath) {
        Remove-Item $taskPath -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $taskPath) {
            "Failed to remove Easy2Convert Task => $taskPath"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Where-Object { $_.Name -match "S-\d-(?:\d+-){4,}" } | Select-Object -ExpandProperty PSChildName
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regPaths = @(
            "Registry::HKU\$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\Easy2Convert"
        )
        foreach ($regPath in $regPaths) {
            if (Test-Path $regPath) {
                Remove-Item $regPath -Recurse -ErrorAction SilentlyContinue
                if (Test-Path $regPath) {
                    "Easy2Convert HKU Registry Removal Unsuccessful => $regPath"
                }
            }
        }
    }
}
