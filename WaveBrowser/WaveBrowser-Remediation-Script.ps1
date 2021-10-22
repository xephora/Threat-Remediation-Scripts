Function intro {
    <#
            .SYNOPSIS
                Remediation script for WaveBrowser Software previously known as WebNavigator.
    
            .DESCRIPTION
                The script will stop browser session, remove files, scheduled tasks and registry keys associated with WebBrowser.

            .EXAMPLE
                It's an automated script, just run the script :P
    
                Description
                -----------
                Kills any browser sessions.
                Removes registry keys associated with Wave Browser Hijacking Software.
                Removes files associated with Wave Browser Hijacking Software.
                Removes the scheduled tasks associated with Wave Browser.
        #>
    }

Function BrowserProcesses {
    "Stopping Browser Sessions"

    Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process iexplore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process SWUpdater -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

Function RemoveWavesorFS {
    "Cleaning WaveBrowser Files"
    
    rm "$env:USERPROFILE\Wavesor Software" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    rm "$env:USERPROFILE\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    rm "$env:USERPROFILE\appdata\local\WaveBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    rm "$env:USERPROFILE\appdata\local\WebNavigatorBrowser" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    rm "$env:USERPROFILE\downloads\Wave Browser*.exe" -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
}

Function RemoveScheduledTasks {
    "Cleaning Scheduled Tasks"
    
    $tasks = Get-ScheduledTask -TaskName *Wave* | Select-Object -ExpandProperty TaskName
    foreach ($i in $tasks) {
        Unregister-ScheduledTask -TaskName $i -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable DirectoryError
    }
}

Function RemoveRegistryKey {
    "Cleaning Registry Keys.."
    
    Remove-Item -Path HKCU:\Software\WaveBrowser -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path HKCU:\Software\Wavesor -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path HKCU:\Software\WebNavigatorBrowser -Recurse -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Wavesor SWUpdater" -ErrorAction SilentlyContinue
}

BrowserProcesses
RemoveWavesorFS
RemoveScheduledTasks
RemoveRegistryKey
