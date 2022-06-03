# This scanner has been archived.  This scanner was used as a test tool.
#!/bin/bash

echo -e "Identifying Java Version:\n"
java -version

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
