#!/bin/bash

# Just show me what's happening
echo "Checking disk usage..."

# Check each line and print warning if over 80%
df -h | grep -v "Filesystem" | while read line; do
    usage=$(echo $line | awk '{print $5}' | tr -d '%')
    mount=$(echo $line | awk '{print $6}')
    
    if [ $usage -gt 80 ]; then
        echo "⚠️  WARNING: $mount is at $usage% full!"
    else
        echo "✅ $mount is at $usage% full (OK)"
    fi
done

echo "Done!"