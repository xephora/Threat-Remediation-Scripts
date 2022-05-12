# Early development phase 05-12-2022
# references https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED='\033[0;31m'
NC='\033[0m'
echo -e "${RED}[+] Enumerating opt: ${NC}\n"
ls -l /opt 2>/dev/null
echo -e "\n${RED}[+] Enumerating shm: {NC}\n"
ls -l /dev/shm 2>/dev/null
echo -e "\n${RED}[+] Enumerating root: ${NC}\n"
echo -e "[+] Root Profile: \n"
ls -l /root 2>/dev/null
echo -e "[+] Root Downloads: \n"
ls -l /root/Downloads 2>/dev/null
echo -e "[+] Root Documents: \n"
ls -l /root/Documents 2>/dev/null
echo -e "[+] Root Desktop: \n"
ls -l /root/Desktop 2>/dev/null
echo -e "[+] Root ssh: \n"
ls -l /root/.ssh 2>/dev/null
echo -e "\n${RED}[+] Looking for persistence in root bashrc: ${NC}\n"
cat /root/.bashrc | grep "alias\|export"
echo -e "\n${RED}[+] Checking user history: ${NC}\n"
x=$(ls /home); for i in $x; do echo "- [+] Checking profile $i: " && cat /home/$i/.bash_history 2>/dev/null | grep "curl\|$
echo -e "\n${RED}[+] Checking interesting processes: ${NC}\n"
x=$(ls /home); for i in $x; do ps -ef --forest | grep $i | grep -v  "kworker\|xfs\|jfs\|grep\|journald\|systemd\|sd-pam\|a$
echo -e "\n${RED}[+] Checking users for bash scripts, elf binaries, python scripts: ${NC}\n"
x=$(ls /home); for i in $x; do find /home/$i | grep "*\.sh\|*\.elf\|*\.py"; done
echo -e "\n${RED}[+] Checking users download folder: ${NC}\n"
x=$(ls /home); for i in $x; do echo "- [+] Profile $i" && ls /home/$i/downloads 2>/dev/null; done
echo -e "\n${RED}[+] Enumerating processes associated with wwwroot or mysql: ${NC}\n"
ps -ef --forest | grep "wwwroot\|mysql"
echo -e "\n${RED}[+] Enumerating ports: ${NC}\n"
netstat -tunlp 2>/dev/null
echo -e "\n${RED}[+] Enumerating IP information ${NC}\n"
ifconfig 2>/dev/null
echo -e "\n${RED}[+] Enumerating passwd file: ${NC}\n"
cat /etc/passwd 2>/dev/null | grep "/bin/bash\|/bin/sh"
