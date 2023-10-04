$headlinesProcess = Get-Process headlines -ErrorAction SilentlyContinue
if ($headlinesProcess) { $headlinesProcess | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 2 }

$user_list = Get-ChildItem 'C:\users\*' | Where-Object { $_.Name -ne 'Public' } | ForEach-Object { $_.Name }
foreach ($user in $user_list) {
    $paths = @( 
        "C:\users\$user\appdata\local\headlines", 
        "C:\users\$user\appdata\roaming\headlines",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\headlines.lnk"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "headlines Removal Unsuccessful => $path"
            }
        }
    }
}

$sid_list = Get-ChildItem -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | Where-Object { $_ -notlike "*_Classes*" }
foreach($sid in $sid_list) {
    $regkey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
    if ((Get-Item $regkey).Property -contains "headlines") {
        Remove-ItemProperty -Path $regkey -Name "headlines" -ErrorAction SilentlyContinue
        if ((Get-Item $regkey).Property -contains "headlines") {
            "headlines Removal Unsuccessful => $regkey.headlines"
        }
    }
}
