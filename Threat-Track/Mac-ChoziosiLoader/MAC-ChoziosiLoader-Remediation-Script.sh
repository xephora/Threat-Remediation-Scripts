###
# TODO:
#  - Experiencing issues with if statements within CrowdStrike environment so manual remediation script was created in the mean-while.
#  - This is a CrowdStrike script which CrowdStrike successfully blocks the activity of persistence.  The LaunchAgents are failing to execute which means the malicious extensions are failing to load.
###
username="USERNAME"
cat "/users/$username/Library/LaunchAgents/com.chrome.extensionsPop.plist" 2>/dev/null | grep "echo" | awk '{print $2}' | base64 -d | awk '{print $8}' | sed 's/:\/\///g' | sed 's/;//g' | sed 's/https//g' 
rm "/Volumes/Application Installer/ChromeInstaller.command" 2>/dev/null
umount -f "/Volumes/Application Installer" 2>/dev/null
MalExt=$(cat /Users/$username/Library/LaunchAgents/com.chrome.extensions.plist 2>/dev/null | grep "echo" | awk '{print $2}' | base64 -d | awk '{print $14}' | sed "s/--load-extension='//g" | sed "s/'//g")
echo "Malicious Extension: $MalExt"
shasum -a 256 "/Users/$username/Library/LaunchAgents/com.chrome.extension.plist" 2>/dev/null
shasum -a 256 "/Users/$username/Library/LaunchAgents/com.chrome.extensions.plist" 2>/dev/null
shasum -a 256 "/Users/$username/Library/LaunchAgents/com.chrome.extensionsPop.plist" 2>/dev/null
shasum -a 256 "/Users/$username/Downloads/*.dmg" 2>/dev/null
rm "/Users/$username/Library/LaunchAgents/com.chrome.extension.plist" 2>/dev/null
rm "/Users/$username/Library/LaunchAgents/com.chrome.extensions.plist" 2>/dev/null
rm "/Users/$username/Library/LaunchAgents/com.chrome.extensionsPop.plist" 2>/dev/null
rm "/Users/$username/downloads/*.dmg" 2>/dev/null
rm -r -d $MalExt 2>/dev/null
