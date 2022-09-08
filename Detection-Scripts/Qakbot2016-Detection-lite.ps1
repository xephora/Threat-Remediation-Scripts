$scheduledTaskfiles = @(gci C:\windows\system32\tasks | where { $_.Name -match '^\{' } | % { $_.FullName })
$condition = [string]::IsNullOrEmpty($scheduledTaskfiles)
if ($condition -eq $true) {
    "[*] Nothing Detected"
    exit
}
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
