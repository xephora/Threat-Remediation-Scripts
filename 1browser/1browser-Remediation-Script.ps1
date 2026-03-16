$processes = @(
    "1browser",
    "updater"
)

foreach ($proc in $processes) {
    $process = Get-Process $proc -ErrorAction SilentlyContinue
    if ($process) {
        $process | Stop-Process -Force -ErrorAction SilentlyContinue
    }
}
Start-Sleep -Seconds 2

$programDirs = Get-ChildItem "C:\Program Files" -Filter "1browser*" -ErrorAction SilentlyContinue

foreach ($dir in $programDirs) {
    if (Test-Path $dir.FullName) {
        Remove-Item $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $dir.FullName) {
            "Failed to remove 1browser directory -> $($dir.FullName)"
        }
    }
}

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    $installers = Get-ChildItem "C:\Users\$user\Downloads" -Filter "1browser*.exe" -ErrorAction SilentlyContinue
    foreach ($installer in $installers) {
        if (Test-Path $installer.FullName) {
            Remove-Item $installer.FullName -Force -ErrorAction SilentlyContinue
            if (Test-Path $installer.FullName) {
                "Failed to remove 1browser installer -> $($installer.FullName)"
            }
        }
    }

    $paths = @(
        "C:\Users\$user\AppData\Local\1browser",
        "C:\Users\$user\Desktop\1Browser.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\1Browser.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\1Browser.lnk",
        "C:\Users\$user\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\1Browser.lnk"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove 1browser user artifact -> $path"
            }
        }
    }
}

$tasks = Get-ScheduledTask -TaskName "1browserUser" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty TaskName

foreach ($task in $tasks) {
    Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
}

$taskPaths = @(
    "C:\Windows\System32\Tasks\1browserUser"
)

foreach ($taskPath in $taskPaths) {
    if (Test-Path $taskPath) {
        Remove-Item $taskPath -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $taskPath) {
            "Failed to remove 1browser scheduled task -> $taskPath"
        }
    }
}

$regHKLM = @(
    "Registry::HKLM\Software\WOW6432Node\1browser"
)

foreach ($reg in $regHKLM) {
    if (Test-Path $reg) {
        Remove-Item $reg -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $reg) {
            "Failed to remove 1browser HKLM registry key -> $reg"
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" |
    Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" |
    ForEach-Object { $_.ToString().Trim() }

foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $regHKU = @(
            "Registry::$sid\Software\1browser",
            "Registry::$sid\Software\Classes\1browserUpdate.Update3WebUser",
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\1browser 1browser"
        )

        foreach ($regPath in $regHKU) {
            if (Test-Path $regPath) {
                Remove-Item $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path $regPath) {
                    "Failed to remove 1browser HKU registry key -> $regPath"
                }
            }
        }

        $runPath = "Registry::$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        $runProps = Get-ItemProperty -Path $runPath -ErrorAction SilentlyContinue

        if ($runProps) {
            $propNames = $runProps.PSObject.Properties |
                Where-Object { $_.MemberType -eq "NoteProperty" } |
                Select-Object -ExpandProperty Name

            foreach ($prop in $propNames) {
                if ($prop -like "1browserUpdaterTaskUser*") {

                    Remove-ItemProperty -Path $runPath -Name $prop -ErrorAction SilentlyContinue

                    if (Get-ItemProperty -Path $runPath -Name $prop -ErrorAction SilentlyContinue) {
                        "Failed to remove 1browser run key value -> $runPath.$prop"
                    }
                }
            }
        }
    }
}
