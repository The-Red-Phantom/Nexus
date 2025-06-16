#!/bin/bash

TARGET="$1"
LOGFILE="/tmp/lockpick_scan_$TARGET.txt"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or domain>"
    exit 1
fi

echo "Lockpick Port Scan - $TARGET" | tee "$LOGFILE"
echo "---" >> "$LOGFILE"
echo "[+] Date: $(date)" >> "$LOGFILE"

# Top 1000 TCP ports with service detection, minimal DNS resolution
nmap -sS -sV -T3 --max-retries 3 --open -Pn "
