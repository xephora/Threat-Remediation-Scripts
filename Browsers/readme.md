# Browsers Remediation script (unified)

### Covered software

1browser, OneBrowser, BBSK (SecureBrowser / BlazeMedia), Ouroborosbrowser, LiteBrowser, ShiftBrowser, Blazer, WebDiscoverBrowser, WaveBrowser, Epibrowser, BrowserAssistant, OneStart and OneLaunch.

This script replaces the individual scripts of these folders (they are left untouched). Adding a software means adding one entry to the `$Definitions` table at the top of the script.

### Actions

For every software the script:

- Detects its artifacts: files, folders, shortcuts, installers, scheduled tasks, registry keys / values, running processes.
- Removes them (scheduled tasks, processes, file system, registry).
- Runs the detection again to confirm that nothing is left.

### RMM output (Datto RMM UDF)

Written to `HKLM:\Software\CentraStage`:

| UDF (default) | Content |
| --- | --- |
| `Custom50` | Detected software, comma separated, e.g. `OneLaunch, WaveBrowser (KO)`. `(KO)` means something is still on the machine. Empty when nothing was found. Cut to 255 characters. |
| `Custom51` | Number of software that were fully removed (`0` when nothing was found). |

Both values are written with `new-itemProperty -Path "HKLM:\Software\CentraStage" -Name <UDF> -PropertyType String -Value $result -Force | Out-Null`. If the `CentraStage` key does not exist the script only prints the result (the key is never created).

The details (what was found, what could not be removed) are printed to the standard output. The exit code is `1` when something could not be removed, `0` otherwise.

### Parameters

```
.\Browsers-Remediation-Script.ps1 [-ListUdf Custom50] [-CountUdf Custom51] [-DetectOnly]
```

- `-ListUdf` / `-CountUdf`: UDF names to write.
- `-DetectOnly`: report only, nothing is removed.

### Side effects avoided compared to the individual scripts

- Processes are never stopped by name (`node`, `setup`, `updater`, `browser`, `chromium`, `chrome`...). A process is only stopped, by PID, when its executable is inside a folder (or is a file) that is about to be removed. No other browser is closed.
- Scheduled tasks are removed with `Unregister-ScheduledTask` (Windows cleans `TaskCache` itself). Task wildcards are limited to the software prefix (`Wave*` became `Wavesor*` and `WaveBrowser*`).
- Entries with a generic name are only removed when their content matches the software: `updater.lnk` and the `Startup Scheduler` task (BrowserAssistant) and the `GoogleChromeAutoLaunch_*` Run value (Shift).
- Installers (`exe` / `msi`) are only searched in `Downloads` and `Desktop` of each profile, not in the whole profile.
- Profiles come from `C:\Users` and from the `ProfileList` registry key. `Public`, `Default`, `Default User` and `All Users` are skipped, reparse points are not followed.
- Works from a 32 or 64 bit PowerShell: the native registry view and the 64 bit `Program Files` / `System32` are used explicitly.
- A software that fails never stops the others, and the result is always published.
- Fixes: the OneStart `Software\Software\Classes\OSBHTML...` typo, the LiteBrowser check on an undefined variable and the `continue` statements outside of a loop (WebDiscoverBrowser, LiteBrowser) that ended the script early.

### Limitations

- Like the original scripts, only the registry hives of the users that are currently logged on are cleaned. Files and folders are cleaned for every profile.
- The script has to run as SYSTEM or as an administrator.
