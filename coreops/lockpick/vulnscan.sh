#!/bin/bash

TARGET="$1"
LOGFILE="/tmp/lockpick_vulnscan_$TARGET.txt"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or domain>"
    exit 1
fi

echo "Lockpick Vuln Scan - $TARGET" | tee "$LOGFILE"
echo "---" >> "$LOGFILE"
echo "[+] Date: $(date)" >> "$LOGFILE"

# Run a safe set of Nmap NSE vuln detection scripts
nmap -sV --script vuln -T3 --max-retries 3 -Pn "$TARGET" -oN "$LOGFILE"

