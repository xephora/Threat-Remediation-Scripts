$streamingProcess = Get-Process streaming -ErrorAction SilentlyContinue
if ($streamingProcess) { $streamingProcess | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }

$user_list = Get-ChildItem 'C:\users\*' | Where-Object { $_.Name -ne 'Public' } | ForEach-Object { $_.Name }
foreach ($user in $user_list) {
    $paths = @( 
        "C:\users\$user\appdata\local\streaming", 
        "C:\users\$user\appdata\roaming\streaming",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\streaming.lnk"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "streaming Removal Unsuccessful => $path"
            }
        }
    }
}

$sid_list = Get-ChildItem -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | Where-Object { $_ -notlike "*_Classes*" }
foreach($sid in $sid_list) {
    $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    if ((Get-Item $regkey).Property -contains "streaming") {
        Remove-ItemProperty -Path $regkey -Name "streaming" -ErrorAction SilentlyContinue
        if ((Get-Item $regkey).Property -contains "streaming") {
            "streaming Removal Unsuccessful => $regkey.streaming"
        }
    }
}
