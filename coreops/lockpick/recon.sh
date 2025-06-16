#!/bin/bash

TARGET="$1"
LOGFILE="/tmp/lockpick_recon_$TARGET.txt"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target IP or domain>"
    exit 1
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
timeout 3 bash -c "exec 3<>/dev/tcp/$TARGET/80; echo -e 'HEAD / HTTP/1.0\r\n' >&3; cat <&3" >> "$LOGFILE" 2>/dev/null

echo -e "\n[+] MAC + Vendor (if local):" >> "$LOGFILE"
arp -a | grep "$TARGET" >> "$LOGFILE" 2>/dev/null

echo -e "\n[+] Traceroute (short):" >> "$LOGFILE"
traceroute -m 5 "$TARGET" >> "$LOGFILE" 2>/dev/null

echo -e "\nRecon complete. Saved to: $LOGFILE"
