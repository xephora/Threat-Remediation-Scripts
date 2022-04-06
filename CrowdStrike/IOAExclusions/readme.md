## IOA Exclusions for Roblox false-positive detections (Archived 04-01-2022)

There has been a high volume of false-positive detections for a Roblox engine.  An exclusion has been created to reduce the noise.

```
Regex Pattern for excluding Roblox by IMAGE FILENAME and COMMAND LINE.  This pattern incorporate arguments that may be used.

IMAGE FILENAME: .*\\Program\s+Files\s+\(x86\)\\Roblox\\Versions\\version-.*\\RobloxPlayerBeta\.exe.*
COMMAND LINE: .*\\Program\s+Files\s+\(x86\)\\Roblox\\Versions\\version-.*\\RobloxPlayerBeta\.exe.*

IMAGE FILENAME: .*\\Users\\.*\\AppData\\Local\\Roblox\\Versions\\version-.*\\RobloxPlayerBeta\.exe.*
COMMAND LINE: .*\\Users\\.*\\AppData\\Local\\Roblox\\Versions\\version-.*\\RobloxPlayerBeta\.exe.*
```
