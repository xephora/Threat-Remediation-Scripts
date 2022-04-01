# Still in the works, may trigger false positives
# if statement for the version number is failing to confirm vulnerable or not, will need to trouble-shoot..

#!/bin/bash
echo -e "Identifying Java Version:\n"
#java -version
ver=$(java -version)
echo -e "\nConfirming Vulnerability: \n"
if [[ "$ver" =~ "1.8" || "$ver" =~ "1.7" || "$ver" =~ "1.6" || "$ver" =~ "1.5" || "$ver" =~ "1.4" || "$ver" =~ "1.3" || "$ver" =~ "1.2" || "$ver" =~ "1.0" ]]; 
then
        echo -e "[+] Not vulnerable\n"
        exit
else
        echo -e "[!] Potentially vulnerable!!\n"
        echo "\nIdentifying Spring Framework: "
        find / -name spring-beans-*.jar 2>/dev/null
        find / 2>/dev/null | grep "CachedIntrospectionResuLts.class"
        echo -e "\nIdentifying War Files on System: "
        find / -name *.war 2>/dev/null
        FILE=/usr/bin/jar
        if [[ -f "$FILE" ]]; then
                echo -e "\nChecking War Files for spring.."
                x=$(find / -name *.war 2>/dev/null)
                for i in $x; do jar tf $i | find -name spring-beans-*.jar; done
        fi
fi
