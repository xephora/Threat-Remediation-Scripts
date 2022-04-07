# ByteFence PUP Remediation script

### Actions
- Terminates processes associated with ByteFence
- Remove ByteFence from the file system.
- Remove ByteFence registry key.
- Performs checks to ensure removal was completed and lets you know if it wasn't successful.

### Description

I created an automated script to remove ByteFence.

### Things to know

Remediation of ByteFence takes a bit longer to remediate. If you are using CrowdStrike to remediate, consider increasing the timeout by 500.

This can be done by adding `-Timeout=500` to the end of the runscript command.
