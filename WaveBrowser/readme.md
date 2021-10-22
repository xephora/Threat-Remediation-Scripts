# Remediation Script for WaveBrowser aka WebNavigator

## Steps to remediate

- Stops browser sessions
- Removes WaveBrowser from the filesystem.
- Removes WaveBrowser scheduled tasks.
- Removes WaveBrowser registry keys

### Why two scripts?
I created an automated script that works well for a single local device. However, this script doesn't work with CrowdStrike due to issues with the environmental variables, so I created a simplified script for this reason.

### Known Issues
- For Windows 7, The removal of scheduled task doesn't work.  However, it still removes the other files, registry keys and kills the processes perfectly fine.
