#!/bin/bash

# Specify the search path
search_directory="/"

# Find all JAR and WAR files
find "$search_directory" -type f \( -name "*.jar" -o -name "*.war" \) | while read -r file; do
    if [[ "$file" == *.jar ]]; then
        # For JAR files, check the manifest
        if unzip -p "$file" META-INF/MANIFEST.MF | grep -q 'Spring-Boot-Version'; then
            spring_boot_version=$(unzip -p "$file" META-INF/MANIFEST.MF | awk -F': ' '/Spring-Boot-Version/ {print $2}' | tr -d '[:space:]')
            echo "$file (Version: $spring_boot_version)" >> results.txt
        fi
    elif [[ "$file" == *.war ]]; then
        # For WAR files, check the MANIFEST.MF in WEB-INF
        if unzip -p "$file" WEB-INF/MANIFEST.MF | grep -q 'Spring-Boot-Version'; then
            spring_boot_version=$(unzip -p "$file" WEB-INF/MANIFEST.MF | awk -F': ' '/Spring-Boot-Version/ {print $2}' | tr -d '[:space:]')
            echo "$file (Version: $spring_boot_version)" >> results.txt
        fi
    fi
done
