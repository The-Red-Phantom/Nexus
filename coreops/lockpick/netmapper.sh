#!/bin/bash

SUBNET="$1"
LOG_DIR="$HOME/Nexus/logs/lockpick"
mkdir -p "$LOG_DIR"
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
LOGFILE="$LOG_DIR/netmap_$NOW.txt"
GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

if [[ -z "$SUBNET" ]]; then
    echo "Usage: $0 <subnet CIDR> (e.g., 192.168.1.0/24)"
    exit 1
fi

if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — some ICMP pings may be blocked or ignored."
fi

echo "=== Lockpick Network Mapper ===" | tee "$LOGFILE"
echo "Target Subnet: $SUBNET" | tee -a "$LOGFILE"
echo "Date: $(date)" >> "$LOGFILE"
echo "-------------------------------" >> "$LOGFILE"

# Ping sweep for live hosts
echo "[*] Scanning for live hosts..." | tee -a "$LOGFILE"
nmap -sn "$SUBNET" | grep "Nmap scan report" | awk '{print $NF}' | tee -a "$LOGFILE"

# OS fingerprinting on live hosts
echo -e "\n[*] Running OS detection on live hosts..." | tee -a "$LOGFILE"
for HOST in $(nmap -sn "$SUBNET" | grep "Nmap scan report" | awk '{print $NF}'); do
    echo -e "\n--- $HOST ---" | tee -a "$LOGFILE"
    nmap -O -T3 "$HOST" | grep -A 5 "OS details" >> "$LOGFILE"
done

echo -e "\n[✓] Network map saved to: $LOGFILE"
