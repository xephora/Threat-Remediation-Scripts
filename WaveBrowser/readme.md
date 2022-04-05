# Remediation Script for WaveBrowser aka WebNavigator

## Steps to remediate

- Stops browser sessions
- Removes WaveBrowser from the filesystem.
- Removes WaveBrowser scheduled tasks.
- Removes WaveBrowser registry keys

### Why multiple scripts?

- The scripts are decided by operating systems and have a BrowserKill feature if needed.  It is not always required as CrowdStrike blocks the activity.

*Update 04-05-2022: *

- There are scripts for both Windows 10 and Windows 7.  If the check shows that WaveBrowser is still in-use and cannot be removed, the browser will need to be killed in which you can utilized the BrowserKill script.  This was done to avoid end-user impact.

### Known Issues
- For Windows 7, The removal of scheduled task doesn't work.  However, it still removes the other files, registry keys and kills the processes perfectly fine.
