$scheduledTaskfiles = @(gci C:\windows\system32\tasks | where { $_.Name -match '^\{' } | % { $_.FullName })
foreach ($file in $scheduledTaskfiles) {
    [string]$taskdata = cat $file
    if ($taskdata -like ".wpl") {
        "`n[!] Detected Qakbot Scheduled Task: $file"
        "[*] Task $file contains:"
        cat $file | select-string ".wpl"
    }
    if ($taskdata -like "*.exe*" -and "*Microsoft*") {
        "`n[!] Detected Qakbot Scheduled Task: $file"
        "[*] Task $file contains:"
        cat $file | select-string ".exe"
    }
}

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
	if ($user -notlike "*Public*") {
        $lnks = @(gci "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -fi "*.lnk" -ErrorAction SilentlyContinue |  % { $_.FullName })
        foreach ($lnk in $lnks) {
            "`n[!] Detected Potential Qakbot shortcut:"
            $lnk
        }
        $dlls = @(gci "C:\Users\$user\AppData\Roaming\Microsoft" -r -fi "*.dll" -ErrorAction SilentlyContinue |  % { $_.FullName })
        foreach ($dll in $dlls) {
            $exists = test-path $dll
            if ($exists -eq $true) {
                "`n[!] Detected Potential Qakbot payload:"
                $dll
            }
        }
    }
}
