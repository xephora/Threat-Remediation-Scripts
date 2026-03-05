$processes = @(
"RemotePC",
"RemotePCUIU",
"RemotePCService",
"ViewerService",
"RPCDownloader",
"RPCPerformanceDownloader",
"RPCPerformanceService",
"RPCPerfViewer"
)

foreach ($proc in $processes) {

    $p = Get-Process $proc -ErrorAction SilentlyContinue
    if ($p) {
        $p | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }

    $p = Get-Process $proc -ErrorAction SilentlyContinue
    if ($p) {
        $p | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

Start-Sleep -Seconds 2

$services = @(
"RPCPerformanceService",
"RPCService",
"ViewerService"
)

foreach ($svcName in $services) {

    $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue

    if ($svc) {

        if ($svc.Status -ne "Stopped") {
            Stop-Service -Name $svcName -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }

        sc.exe delete "$svcName" | Out-Null

        $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
        if ($svc) {
            "Failed to remove RemotePC service -> $svcName"
        }
    }
}

$tasks = @(
"RemotePC",
"RPCPerformanceHealthCheck",
"RPCServiceHealthCheck"
)

foreach ($task in $tasks) {

    $taskPath = "C:\Windows\System32\Tasks\$task"

    if (Test-Path $taskPath) {

        schtasks /End /TN $task 2>$null
        schtasks /Delete /TN $task /F 2>$null

        if (Test-Path $taskPath) {
            Remove-Item $taskPath -Force -ErrorAction SilentlyContinue
        }

        if (Test-Path $taskPath) {
            "Failed to remove RemotePC scheduled task -> $task"
        }
    }
}


$user_list = Get-Item C:\users\* | Select-Object Name -ExpandProperty Name

foreach ($user in $user_list) {

    $downloadsInstaller = "C:\users\$user\Downloads\RemotePC*.exe"

    if (Test-Path $downloadsInstaller) {
        Remove-Item $downloadsInstaller -Force -ErrorAction SilentlyContinue

        if (Test-Path $downloadsInstaller) {
            "Failed to remove RemotePC installer -> $downloadsInstaller"
        }
    }

    $roamingPath = "C:\Users\$user\AppData\Roaming\RemotePC"

    if (Test-Path $roamingPath) {
        Remove-Item $roamingPath -Force -Recurse -ErrorAction SilentlyContinue

        if (Test-Path $roamingPath) {
            "Failed to remove RemotePC folder -> $roamingPath"
        }
    }

    $shortcuts = @(
        "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\RemotePC.lnk",
        "C:\Users\$user\Desktop\RemotePC.lnk"
    )

    foreach ($shortcut in $shortcuts) {

        if (Test-Path $shortcut) {
            Remove-Item $shortcut -ErrorAction SilentlyContinue

            if (Test-Path $shortcut) {
                "Failed to remove RemotePC shortcut -> $shortcut"
            }
        }
    }
}


$systemShortcuts = @(
"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RemotePC.lnk",
"C:\Users\Public\Desktop\RemotePC.lnk"
)

foreach ($shortcut in $systemShortcuts) {

    if (Test-Path $shortcut) {
        Remove-Item $shortcut -ErrorAction SilentlyContinue

        if (Test-Path $shortcut) {
            "Failed to remove RemotePC shortcut -> $shortcut"
        }
    }
}


$folders = @(
"C:\Program Files (x86)\RemotePC",
"C:\Program Files\RemotePCPrinter",
"C:\ProgramData\RemotePC",
"C:\ProgramData\RemotePC Performance",
"C:\ProgramData\RemotePC Performance Host",
"C:\ProgramData\RemotePC Performance Viewer"
)

foreach ($folder in $folders) {

    if (Test-Path $folder) {
        Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue

        if (Test-Path $folder) {
            "Failed to remove RemotePC folder -> $folder"
        }
    }
}


$registryPaths = @(
"Registry::HKLM\SOFTWARE\RemotePCPrinter",
"Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE\RemotePC"
)

foreach ($path in $registryPaths) {

    if (Test-Path $path) {
        Remove-Item $path -Recurse -ErrorAction SilentlyContinue

        if (Test-Path $path) {
            "Failed to remove RemotePC registry key -> $path"
        }
    }
}


$uninstallKey = "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AA4B39D8-F8D7-43D2-9797-4E887760E360}"

if (Test-Path $uninstallKey) {

    Remove-Item $uninstallKey -Recurse -ErrorAction SilentlyContinue

    if (Test-Path $uninstallKey) {
        "Failed to remove RemotePC uninstall key -> $uninstallKey"
    }
}
