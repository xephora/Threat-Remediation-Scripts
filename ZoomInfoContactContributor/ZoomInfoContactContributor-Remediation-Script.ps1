$process = Get-Process coordinator -ErrorAction SilentlyContinue
if ($process) {
    $process | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Start-Sleep -Seconds 2

$user_list = Get-Item C:\Users\* | Select-Object -ExpandProperty Name
foreach ($user in $user_list) {
    $installers = Get-ChildItem "C:\Users\$user\Downloads" -Filter "ZoomInfoContactContributor*.exe" -ErrorAction SilentlyContinue
    foreach ($installer in $installers) {
        if (Test-Path $installer.FullName) {
            Remove-Item $installer.FullName -Force -ErrorAction SilentlyContinue
            if (Test-Path $installer.FullName) {
                "Failed to remove ZoomInfo installer -> $($installer.FullName)"
            }
        }
    }

    $paths = @(
        "C:\Users\$user\AppData\Local\ZoomInfoCEUtility",
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\ZoomInfo Contact Contributor"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path $path) {
                "Failed to remove ZoomInfo artifact -> $path"
            }
        }
    }
}

$sid_list = Get-Item -Path "Registry::HKU\S-*" |
    Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+" |
    ForEach-Object { $_.ToString().Trim() }

foreach ($sid in $sid_list) {
    if ($sid -notlike "*_Classes*") {
        $runPath = "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Run"
        $runProps = Get-ItemProperty -Path $runPath -ErrorAction SilentlyContinue

        if ($runProps) {
            $propNames = $runProps.PSObject.Properties |
                Where-Object { $_.MemberType -eq "NoteProperty" } |
                Select-Object -ExpandProperty Name

            foreach ($prop in $propNames) {
                if ($prop -like "ZoomInfo Contact Contributor*") {

                    Remove-ItemProperty -Path $runPath -Name $prop -ErrorAction SilentlyContinue

                    if (Get-ItemProperty -Path $runPath -Name $prop -ErrorAction SilentlyContinue) {
                        "Failed to remove ZoomInfo run key value -> $runPath.$prop"
                    }
                }
            }
        }

        $regHKU = @(
            "Registry::$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZoomInfo Contact Contributor"
        )

        foreach ($regPath in $regHKU) {
            if (Test-Path $regPath) {
                Remove-Item $regPath -Recurse -Force -ErrorAction SilentlyContinue
                if (Test-Path $regPath) {
                    "Failed to remove ZoomInfo HKU registry key -> $regPath"
                }
            }
        }
    }
}
