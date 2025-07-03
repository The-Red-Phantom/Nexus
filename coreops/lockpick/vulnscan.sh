#!/bin/bash

TARGET="$1"
LOG_DIR="$HOME/Nexus/logs/lockpick"
LOGFILE="$LOG_DIR/lockpick_vulnscan_$TARGET.txt"
GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

mkdir -p "$LOG_DIR"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or domain>"
    exit 1
fi

if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — outbound scanning may be affected."
    echo "[⚠] Ghost mode enabled during scan." >> "$LOGFILE"
fi

echo "Lockpick Vuln Scan - $TARGET" | tee "$LOGFILE"
echo "---" >> "$LOGFILE"
echo "[+] Date: $(date)" >> "$LOGFILE"

# Run safe vuln scripts
nmap -sV --script vuln -T3 --max-retries 3 -Pn "$TARGET" | tee -a "$LOGFILE"

echo "[✓] Vulnerability scan complete. Log saved to: $LOGFILE"

"$HOME/Nexus/coreops/mcl/encrypt_log.sh" "$LOGFILE"
