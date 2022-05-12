#########################################################################################################################################
# TODO:                                                                                                                                 #
#  - Experiencing issues with if statements within CrowdStrike environment so manual remediation script was created in the mean-while.  #
#########################################################################################################################################
username="USERNAME"
# Retrieves Dropper domain from initial bash script which downloads the malicious extension to disk
DropperDomain=$(cat "/Volumes/Application Installer/ChromeInstaller.command" 2>/dev/null | grep "> \$BPATH/\$IPATH.zip" | sed 's/curl\ -s\ //g' | sed 's/  //g' | sed 's/> \$BPATH\/\$IPATH\.zip \/dev\/null//g')
echo "Dropper Domain: $DropperDomain" 2>/dev/null
# Retrieves hash for initial bash script
shasum -a 256 "/Volumes/Application Installer/ChromeInstaller.command" 2>/dev/null
# Retrieves C2 Server
cat "/users/$username/Library/LaunchAgents/com.chrome.extensionsPop.plist" 2>/dev/null | grep "echo" | awk '{print $2}' | base64 -d | awk '{print $8}' | sed 's/:\/\///g' | sed 's/;//g' | sed 's/https//g' 
# Clean script
rm "/Volumes/Application Installer/ChromeInstaller.command" 2>/dev/null
# Unmounts malicious disk image
umount -f "/Volumes/Application Installer" 2>/dev/null
# Retrieves malicious extension path from startup launchagent
MalExt=$(cat /Users/$username/Library/LaunchAgents/com.chrome.extensions.plist 2>/dev/null | grep "echo" | awk '{print $2}' | base64 -d | awk '{print $14}' | sed "s/--load-extension='//g" | sed "s/'//g")
echo "Malicious Extension: $MalExt"
# Retrives hashes for all persistence
shasum -a 256 "/Users/$username/Library/LaunchAgents/com.chrome.extension.plist" 2>/dev/null
shasum -a 256 "/Users/$username/Library/LaunchAgents/com.chrome.extensions.plist" 2>/dev/null
shasum -a 256 "/Users/$username/Library/LaunchAgents/com.chrome.extensionsPop.plist" 2>/dev/null
# General disk image enumeration of user (This one command mostly contains false-positives, but used for documentation reasons)
shasum -a 256 "/Users/$username/Downloads/*.dmg" 2>/dev/null
# Cleans persistence
rm "/Users/$username/Library/LaunchAgents/com.chrome.extension.plist" 2>/dev/null
rm "/Users/$username/Library/LaunchAgents/com.chrome.extensions.plist" 2>/dev/null
rm "/Users/$username/Library/LaunchAgents/com.chrome.extensionsPop.plist" 2>/dev/null
# Cleans disk images from user download folder
rm "/Users/$username/downloads/*.dmg" 2>/dev/null
# Removes malicious extension from system.
rm -r -d $MalExt 2>/dev/null
