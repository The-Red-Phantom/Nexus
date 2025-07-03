#!/bin/bash

TARGET="$1"
LOG_DIR="$HOME/Nexus/logs/lockpick"
LOGFILE="$LOG_DIR/lockpick_scan_${TARGET}.txt"
GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

mkdir -p "$LOG_DIR"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or domain>"
    exit 1
fi

# 🔻 INSERT THIS BLOCK
if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — outbound traffic may be blocked."
    echo "[⚠] Ghost mode active during scan." >> "$LOGFILE"
fi
# 🔺 END BLOCK

echo "Lockpick Port Scan - $TARGET" | tee "$LOGFILE"
echo "---" >> "$LOGFILE"
echo "[+] Date: $(date)" >> "$LOGFILE"

# Top 1000 TCP ports with service detection, minimal DNS resolution
nmap -sS -sV -T3 --max-retries 3 --open -Pn "$TARGET" | tee -a "$LOGFILE"

