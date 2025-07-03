#!/bin/bash

TARGET="$1"
LOG_DIR="$HOME/Nexus/logs/lockpick"
LOGFILE="$LOG_DIR/smb_enum_$TARGET.txt"
GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

mkdir -p "$LOG_DIR"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or hostname>"
    exit 1
fi

if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — SMB traffic may be filtered or blocked."
fi

echo "=== SMB Enumeration - $TARGET ===" | tee "$LOGFILE"
echo "[+] Date: $(date)" >> "$LOGFILE"
echo "[+] Target: $TARGET" >> "$LOGFILE"
echo "-------------------------------" >> "$LOGFILE"

# 1. Check for open SMB ports
echo "[*] Scanning SMB ports (139, 445)..." | tee -a "$LOGFILE"
nmap -p 139,445 --open -T3 "$TARGET" >> "$LOGFILE"

# 2. Anonymous share check
echo -e "\n[*] Checking for anonymous shares..." | tee -a "$LOGFILE"
smbclient -L "$TARGET" -N 2>/dev/null | tee -a "$LOGFILE"

# 3. Grab host and domain info via SMB
echo -e "\n[*] Attempting enum4linux-lite..." | tee -a "$LOGFILE"
enum4linux-ng -A "$TARGET" 2>/dev/null | tee -a "$LOGFILE"

echo -e "\n[✓] SMB enumeration complete. Log saved to: $LOGFILE"
