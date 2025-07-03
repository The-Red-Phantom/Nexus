#!/bin/bash

TARGET="$1"
LOG_DIR="$HOME/Nexus/logs/lockpick"
LOGFILE="$LOG_DIR/lockpick_credcheck_$TARGET.txt"
GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

mkdir -p "$LOG_DIR"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or domain>"
    exit 1
fi

if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — probing may be limited or blocked."
fi

echo "Lockpick Credential Check - $TARGET" | tee "$LOGFILE"
echo "---" >> "$LOGFILE"
echo "[+] Date: $(date)" >> "$LOGFILE"

# Anonymous FTP
echo "[*] Checking anonymous FTP..." | tee -a "$LOGFILE"
timeout 5 bash -c "echo -e 'USER anonymous\nPASS test@test.com\nQUIT' | nc -w 3 $TARGET 21" | grep -i "230" >> "$LOGFILE" && \
    echo "[+] Anonymous FTP access allowed!" | tee -a "$LOGFILE"

# SSH banner grab
echo "[*] Checking SSH banner..." | tee -a "$LOGFILE"
timeout 5 nc -w 3 "$TARGET" 22 | head -n 1 >> "$LOGFILE"

echo "[✓] Credential check complete. Log saved to: $LOGFILE"
