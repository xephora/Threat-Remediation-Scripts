$process = Get-Process UpdateTask -ErrorAction SilentlyContinue
if ($process) { $process | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }
$process = Get-Process SaUpdate -ErrorAction SilentlyContinue
if ($process) { $process | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }

$path = "C:\Program Files (x86)\Ask.com"
if (test-path $path) {
    rm $path -Force -Recurse -ErrorAction SilentlyContinue
    if (test-path $path) {
        "[!] Failed to remove Ask Toolbar -> $path"
    }
}

$task = "C:\windows\system32\tasks\Scheduled Update for Ask Toolbar"
if (test-path $task) {
    rm $task -ErrorAction SilentlyContinue
    if (test-path $task) {
        "[!] Failed to remove Ask Toolbar => $task"
    }
}

$path = "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\Scheduled Update for Ask Toolbar"
if (test-path $path) {
    Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
    if (test-path $path) {
        "[!] Failed to remove Ask Toolbar -> $path"
    }
}

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $path = "Registry::$sid\Software\Ask.com"
        if (test-path $path) {
            Remove-Item -Path $path -Recurse -ErrorAction SilentlyContinue
            if (test-path $path) {
                "[!] Failed to remove Ask Toolbar => $path"
            }
        }
    }
}
