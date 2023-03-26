# Script still undergoing work.  It can be used if you please, but still too early.
echo "[+] Startup paths"

echo "/etc/systemd/system/ -> System-wide custom service files"
ls -la /etc/systemd/system/ 2>/dev/null

echo "/lib/systemd/system/ -> Default service files provided by packages"
ls -la /lib/systemd/system/ 2>/dev/null

echo "/etc/init.d/ -> System-wide SysV init script"
ls -la /etc/init.d/ 2>/dev/null

echo "/etc/xdg/autostart/ -> System-wide autostart files"
ls -la /etc/xdg/autostart/ 2>/dev/null

echo "/etc/profile -> System-wide login script"
cat /etc/profile 2>/dev/null

echo "/etc/profile.d/ -> Additional system-wide login scripts"

echo "/etc/bash.bashrc ->  System-wide non-login script"

cat "/etc/bash.bashrc" 2>/dev/null

echo "[+] temp profiles"
ls -la /tmp/ 2>/dev/null
ls -la /var/tmp/ 2>/dev/null

echo "[+] persistence"

echo "/etc/cron.d/"
ls -la /etc/cron.d/ 2>/dev/null

echo "/etc/cron.daily/"
ls -la /etc/cron.daily/ 2>/dev/null

echo "/etc/cron.hourly/"
ls -la /etc/cron.hourly/ 2>/dev/null

echo "/etc/cron.weekly/"
ls -la /etc/cron.weekly/ 2>/dev/null

echo "/etc/cron.monthly/"
ls -la /etc/cron.monthly/ 2>/dev/null

echo "/var/spool/cron/crontabs/"
ls -la /var/spool/cron/crontabs/ 2>/dev/null

echo "[+] Removable media"

echo "/media/ -> removable media"
ls -la /media/ 2>/dev/null

user_dirs=$(ls -1 /home/ | grep -v '^root$')
for username in $user_dirs; do
    echo "Processing user: $username"

    echo "/home/$username/.config/autostart/ -> user autostart files"
    ls -la "/home/$username/.config/autostart/" 2>/dev/null

    echo "/home/$username -> user login scripts .bash_profile, .bash_login, and .profile"
    cat "/home/$username/.bash_profile" 2>/dev/null
    cat "/home/$username/.bash_login" 2>/dev/null
    cat "/home/$username/.profile" 2>/dev/null
    cat "/home/$username/.bashrc" 2>/dev/null

    echo "User media:"
    ls -la "/media/$username/" 2>/dev/null

    echo "[+] Profile data"
    ls -la "/home/$username/Downloads" 2>/dev/null
    ls -la "/home/$username/Documents" 2>/dev/null
    ls -la "/home/$username/Desktop" 2>/dev/null
    echo "---------------------------------------------"
done


echo "[+] Checking mounts"
mount

echo "[+] Checking disks"
df -h

echo "[+] Checking for active smb shares"
cat /etc/samba/smb.conf 2>/dev/null

echo "[+] Checking active NFS shares on your Linux system"
cat /etc/exports 2>/dev/null

echo "[+] Checking active processes with associated child processes"
ps -ef --forest

echo "[+] Checking for active services"
systemctl list-units --type=service --state=active

echo "[+] Checking for users on system"
cat /etc/passwd
