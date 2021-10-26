# DriverSupportAOsvc Remediation script

### Actions
- Terminates processes associated with DriverSupportAOsvc
- Remove DriverSupportAOsvc from the file system.
- Remove DriverSupportAOsvc registry keys.
- Performs checks to ensure removal was completed and lets you know if it wasn't successful.

### Description

I created an automated script to remove DriverSupportAOsvc.  This script does not require CrowdStrike to run, however, I did create this script for CrowdStrike.  The script was made because Crowdstrike does not know how to interpret environmental variables properly.  If you experience any issues running the script, feel free to drop in an issue.
