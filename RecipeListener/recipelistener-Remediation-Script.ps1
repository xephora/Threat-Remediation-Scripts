$process = Get-Process "Recipe Finder - Recipe Lister" -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $paths = @(
            "C:\Users\$user\Downloads\RecipeLister*.exe",
            "C:\Users\$user\AppData\Roaming\recipe-finder"
        )
        foreach ($path in $paths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $path) {
                    Write-Host "Failed to remove Recipe Listener -> $path"
                }
            }
        }
    }
}
