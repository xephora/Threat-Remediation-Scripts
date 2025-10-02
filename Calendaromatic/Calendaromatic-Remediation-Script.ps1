$process = Get-Process Calendaromatic -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
$process = Get-Process calendaromatic-win_x64 -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}
$process = Get-Process msedgewebview2 -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 2
$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    $paths = @(
        "C:\users\$user\Downloads\7ZSfxMod*.exe",
        "C:\users\$user\Downloads\EPIC Universe*.exe",
    	"C:\Users\$user\Downloads\calendaromatic*.exe",
        "C:\Users\$user\AppData\Roaming\calendaromatic-win_x64.exe",
        "C:\Users\$user\AppData\Local\Temp\7ZipSfx.000",
        "C:\Users\$user\AppData\Local\calendaromatic"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove Calendaromatic -> $path"
            }
        }
    }
}

$reg_keys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellCompatibility\Applications\Calendaromatic.exe",
    "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Compatibility32\Calendaromatic",
    "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths\calendaromatic-win_x64.exe",
    "Registry::HKLM\Software\Classes\AppID\Calendaromatic.exe",
    "Registry::HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Custom\calendaromatic-win_x64.exe"
)
foreach ($reg in $reg_keys) {
    if (Test-Path -Path $reg) {
        Remove-Item -Path $reg -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path -Path $reg) {
            "Failed to remove Calendaromatic => $reg"
        }
    }
}

$reg_value_paths = @(
    @{
        Path = "Registry::HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_LOCALMACHINE_LOCKDOWN"
        Value = "Calendaromatic.exe"
    },
    @{
        Path = "Registry::HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_PROTOCOL_LOCKDOWN"
        Value = "Calendaromatic.exe"
    }
)

foreach ($entry in $reg_value_paths) {
    $path = $entry.Path
    $valueName = $entry.Value
    if (Test-Path $path) {
        $props = (Get-ItemProperty -Path $path -ErrorAction SilentlyContinue).PSObject.Properties.Name
        if ($props -contains $valueName) {
            Remove-ItemProperty -Path $path -Name $valueName -ErrorAction SilentlyContinue
            $props = (Get-ItemProperty -Path $path -ErrorAction SilentlyContinue).PSObject.Properties.Name
            if ($props -contains $valueName) {
                "Failed to remove registry value: $path\$valueName"
            }
        }
    }
}

$runKeys = @(
    "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)
foreach ($key in $runKeys) {
    $props = (Get-ItemProperty -Path $key -ErrorAction SilentlyContinue).PSObject.Properties
    foreach ($prop in $props) {
        if ($prop.Name -like "*calendaromatic*") {
            Remove-ItemProperty -Path $key -Name $prop.Name -ErrorAction SilentlyContinue
            $verify = (Get-ItemProperty -Path $key -ErrorAction SilentlyContinue).PSObject.Properties.Name -contains $prop.Name
            if ($verify) {
                "Failed to remove Calendaromatic => $key.$($prop.Name)"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" | ForEach-Object { $_.ToString().Trim() }
foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $path = "Registry::$sid\Software\Classes\Applications\calendaromatic-win_x64.exe"
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove Calendaromatic => $path"
            }
        }

        $runPath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        $props = (Get-ItemProperty -Path $runPath -ErrorAction SilentlyContinue).PSObject.Properties
        foreach ($prop in $props) {
            if ($prop.Name -like "*calendaromatic*") {
                Remove-ItemProperty -Path $runPath -Name $prop.Name -ErrorAction SilentlyContinue
                $verify = (Get-ItemProperty -Path $runPath -ErrorAction SilentlyContinue).PSObject.Properties.Name -contains $prop.Name
                if ($verify) {
                    "Failed to remove Calendaromatic => $runPath.$($prop.Name)"
                }
            }
        }
        $storePath = "Registry::$sid\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store"
        if (Test-Path $storePath) {
            $props = (Get-ItemProperty -Path $storePath -ErrorAction SilentlyContinue).PSObject.Properties
            foreach ($prop in $props) {
                if ($prop.Name -like "*Calendaromatic*") {
                    Remove-ItemProperty -Path $storePath -Name $prop.Name -ErrorAction SilentlyContinue
                    $verify = (Get-ItemProperty -Path $storePath -ErrorAction SilentlyContinue).PSObject.Properties.Name -contains $prop.Name
                    if ($verify) {
                        "Failed to remove Calendaromatic => $storePath.$($prop.Name)"
                    }
                }
            }
        }
    }
}
