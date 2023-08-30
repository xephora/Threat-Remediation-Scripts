# Investigate the following account below.  Please replace `<username>` with the target username below:
username="<USERNAME>"

echo "Checking cronjobs"
echo "/var/at/tabs"
ls -l /var/at/tabs
echo -e "\n\n"
echo "Checking System Startups"
echo "/Library/LaunchAgents"
ls -l /Library/LaunchAgents
echo -e "\n\n"
echo "Checking System Services"
echo "/Library/LaunchDaemons"
ls -l /Library/LaunchDaemons
echo -e "\n\n"
echo "Checking System Appdata"
ls -l "/Library/Application Support"
echo -e "\n\n"
echo "Checking user downloads folder for suspicious install packages"
ls -l /Users/$username/downloads/*.pkg 2>/dev/null
ls -l /Users/$username/downloads/*.dmg 2>/dev/null
ls -l /Users/$username/downloads/*.zip 2>/dev/null
ls -l /Users/$username/downloads/*.7z 2>/dev/null
ls -l /Users/$username/downloads/*.tar.gz 2>/dev/null
ls -l /Users/$username/downloads/*.rar 2>/dev/null
echo -e "\n\n"
echo "Checking user $username application data folder"
echo "/Users/$username/Library"
ls -l "/Users/$username/Library"
echo -e "\n\n"
echo "/Users/$username/Library/Application Support"
ls -l "/Users/$username/Library/Application Support"
echo -e "\n\n"
echo "Checking user startup location"
echo "/Users/$username/Library/LaunchAgents"
ls -l "/Users/$username/Library/LaunchAgents"
echo -e "\n\n"
echo "Checking Applications"
echo "/Applications"
ls -l /Applications
echo -e "\n\n"
echo "Checking User specific Processes"
ps aux | grep "Application Support"
echo -e "\n\n"
echo "Checking active processes associated with an application"
ps aux | grep "/Applications/"
echo -e "\n\n"
echo "Checking connections associated with applications within users profile"
netstat -tunl | grep "/Library/Application Support\|/tmp/"
echo -e "\n\n"
echo "Checking root profile"
echo "/var/root"
ls -l /var/root
echo -e "\n\n"

echo -e "\n[+] Checking all users Library for hidden files/directories"
for i in $(ls /Users | grep -v "\."); do echo "/Users/$i/Library" && ls "/Users/$i/Library" 2>/dev/null | grep -E "^\.[a-zA-Z0-9\-]+"; done

echo -e "\n[+] Checking all users Application Support for hidden files/directories"
for i in $(ls /Users | grep -v "\."); do echo "/Users/$i/Library/Application Support" && ls "/Users/$i/Library/Application Support" 2>/dev/null | grep -E "^\.[a-zA-Z0-9\-]+"; done
