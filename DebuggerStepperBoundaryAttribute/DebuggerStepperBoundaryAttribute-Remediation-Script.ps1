$process = Get-Process nw -ErrorAction SilentlyContinue
if ($process) { $process | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }
sleep 2

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $path = "C:\Users\$user\AppData\Roaming\DebuggerStepperBoundaryAttribute"
        if (test-path $path) {
            rm -Path $path -Recurse -ErrorAction SilentlyContinue
            if (test-path $path) {
                "[!] Failed to remove DebuggerStepperBoundaryAttribute -> $path"
            }
        }
    }
}

$sid_list = Get-ChildItem -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | Where-Object { $_ -notlike "*_Classes*" }
foreach($sid in $sid_list) {
    $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    if ((Get-Item $regkey).Property -contains "DebuggerStepperBoundaryAttribute") {
        Remove-ItemProperty -Path $regkey -Name "DebuggerStepperBoundaryAttribute" -ErrorAction SilentlyContinue
        if ((Get-Item $regkey).Property -contains "DebuggerStepperBoundaryAttribute") {
            "[!] Failed to remove DebuggerStepperBoundaryAttribute => $regkey.DebuggerStepperBoundaryAttribute"
        }
    }
}
