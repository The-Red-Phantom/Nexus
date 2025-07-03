#!/bin/bash

TARGET="$1"
LOG_DIR="$HOME/Nexus/logs/lockpick"
LOGFILE="$LOG_DIR/lockpick_recon_${TARGET}.txt"
GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

mkdir -p "$LOG_DIR"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or domain>"
    exit 1
fi

# Ghost Mode Check
if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — outbound traffic may be blocked."
    echo "[⚠] Ghost mode active during recon." >> "$LOGFILE"
fi

echo "Recon started for $TARGET" | tee "$LOGFILE"
echo "---" >> "$LOGFILE"
echo "[+] Date: $(date)" >> "$LOGFILE"
echo "[+] Target: $TARGET" >> "$LOGFILE"

echo -e "\n[+] DNS Lookup:" >> "$LOGFILE"
host "$TARGET" >> "$LOGFILE" 2>/dev/null

echo -e "\n[+] Ping TTL Fingerprint:" >> "$LOGFILE"
ping -c 1 "$TARGET" | grep "ttl=" >> "$LOGFILE" 2>/dev/null

echo -e "\n[+] Banner Grabbing (Port 80):" >> "$LOGFILE"
timeout 3 bash -c "exec 3<>/dev/tcp/$TARGET/80; echo -e 'HEAD / HTTP/1.0\r\n\r\n' >&3; cat <&3" >> "$LOGFILE" 2>/dev/null

echo -e "\n[+] MAC + Vendor (if local):" >> "$LOGFILE"
arp -a | grep "$TARGET" >> "$LOGFILE" 2>/dev/null

echo -e "\n[+] Traceroute (short):" >> "$LOGFILE"
traceroute -m 5 "$TARGET" >> "$LOGFILE" 2>/dev/null

echo -e "\n[✓] Recon complete. Saved to: $LOGFILE"
