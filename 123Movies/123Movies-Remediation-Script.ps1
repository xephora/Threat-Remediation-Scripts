$processNames = @("123movies", "Update")
foreach ($name in $processNames) {
    $process = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($process) {
        $process | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    $process = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($process) {
        $process | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    $process = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($process) {
        $process | Stop-Process -Force -ErrorAction SilentlyContinue
    }
}

Start-Sleep -Seconds 2
$user_list = Get-Item C:\Users\* | Select-Object Name -ExpandProperty Name
foreach ($user in $user_list) {
    if ($user -notlike "*Public*") {
        $exePaths = @(Get-ChildItem -Path "C:\Users\$user" -Recurse -Filter "123Movies*.exe" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
        foreach ($exe in $exePaths) {
            if (Test-Path -Path $exe) {
                Remove-Item $exe -Force -ErrorAction SilentlyContinue
                if (Test-Path -Path $exe) {
                    "Failed to remove 123Movies EXE => $exe"
                }
            }
        }

        $folders = @(
            "C:\Users\$user\AppData\Local\123movies",
            "C:\Users\$user\AppData\Roaming\123movies"
        )
        foreach ($folder in $folders) {
            if (Test-Path $folder) {
                Remove-Item $folder -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path $folder) {
                    "Failed to remove 123Movies folder => $folder"
                }
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $uninstallKey = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\123movies"
        if (Test-Path $uninstallKey) {
            Remove-Item $uninstallKey -Recurse -ErrorAction SilentlyContinue
            if (Test-Path $uninstallKey) {
                "Failed to remove 123Movies uninstall key => $uninstallKey"
            }
        }

        $runKeyPath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        $valueName = "com.squirrel.123movies.123movies"
        $keyExists = (Get-ItemProperty -Path $runKeyPath -ErrorAction SilentlyContinue).PSObject.Properties.Name -contains $valueName
        if ($keyExists) {
            Remove-ItemProperty -Path $runKeyPath -Name $valueName -ErrorAction SilentlyContinue
            $keyExists = (Get-ItemProperty -Path $runKeyPath -ErrorAction SilentlyContinue).PSObject.Properties.Name -contains $valueName
            if ($keyExists) {
                "Failed to remove 123Movies run key => $runKeyPath.$valueName"
            }
        }
    }
}
