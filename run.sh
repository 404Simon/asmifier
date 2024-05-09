#!/bin/bash

# Der Name der Java-Datei ohne Erweiterung als Argument übergeben
input=$1

# if $2 is not set or empty, set debug_info to empty string
if [ -z "$2" ]; then
    debug_info=""
    echo "Debug-Informationen werden nicht hinzugefügt."
else
    debug_info="-g"
    echo "Debug-Informationen werden hinzugefügt."
fi

# Kompilieren der Java-Datei mit javac8
javac ${debug_info} -source 8 -target 8 ${input}.java

# Überprüfen, ob die Kompilierung erfolgreich war
if [ $? -eq 0 ]; then
    echo "Kompilierung erfolgreich."

    # Verwenden von ASMifier, um den Bytecode der .class-Datei zu analysieren und in eine neue Java-Datei umzuwandeln
    java -cp asm-all-5.2.jar org.objectweb.asm.util.ASMifier ${input}.class > ${input}Dump.java

    if [ $? -eq 0 ]; then
	echo "${input}Dump.java wurde erfolgreich erstellt."
	echo -e "\n###### DUMP ######\n"
	cat ${input}Dump.java
	echo -e "\n###### DUMP ######\n"
    else
        echo "Fehler beim ASMifier-Prozess."
    fi

    java -jar jd-cli.jar ${input}.class > ${input}JD.java
    if [ $? -eq 0 ]; then
    echo "${input}JD.java wurde erfolgreich erstellt."
    echo -e "\n###### JD ######\n"
    cat ${input}JD.java
    echo -e "\n###### JD ######\n"
    else
        echo "Fehler beim JD-Prozess."
    fi
else
    echo "Fehler bei der Kompilierung von ${input}.java"
fi

