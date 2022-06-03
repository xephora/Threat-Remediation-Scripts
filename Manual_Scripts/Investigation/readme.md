# Useful investigation scripts to enumerate the system

### Designed for CrowdStrike, but can be used locally.

Please be sure to replace the username placeholder with the target username you want to investigate.  Example below:

```
Windows
$username = "<USERNAME>" => $username = "admin"

MAC
username="<USERNAME>" => username="admin"
```

### Things to know

- This script does not thoroughly investigate through the system, the script is a light weight tool to quickly enumerate a host to identify suspicious activity.  You can use these scripts as a starting point to assist you with your investigation.
- The script will continue to be improved over-time and additional features will be added.
