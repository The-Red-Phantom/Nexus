#!/bin/bash

# lockpick.sh – AeonCore Red Team Module: LOCKPICK

LOG_DIR="$HOME/Nexus/logs/lockpick"
LOG_FILE="$LOG_DIR/lockpick_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_DIR"

echo -e "\e[1;31m[LOCKPICK MODULE]\e[0m Legal use only. You agree you are authorized to run this scan."

read -p "Enter target IP or domain: " TARGET
read -p "Are you authorized to scan this? (yes/no): " LEGAL

if [[ "${LEGAL,,}" != "yes" ]]; then
  echo "[LOCKPICK] Authorization not confirmed. Exiting."
  exit 1
fi

echo -e "\n[+] Scanning $TARGET..." | tee -a "$LOG_FILE"
echo "Target: $TARGET" >> "$LOG_FILE"
date >> "$LOG_FILE"

# === Begin Recon ===
{
  echo -e "\n--- PING ---"
  ping -c 3 "$TARGET"

  echo -e "\n--- WHOIS ---"
  whois "$TARGET" || echo "WHOIS failed."

  echo -e "\n--- NMAP (Top 1000 ports) ---"
  nmap -T4 -F "$TARGET"
} >> "$LOG_FILE" 2>&1

echo -e "\n[LOCKPICK] Scan complete. Log saved to: $LOG_FILE"

