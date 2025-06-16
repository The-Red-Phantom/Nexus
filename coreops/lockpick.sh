#!/bin/bash

# lockpick.sh – Basic red team utility
# AeonCore Submodule: Lockpick

TARGET_FILE="/tmp/lockpick_target.txt"
LOG_FILE="/tmp/lockpick_log.txt"

echo -e "\e[1;31m[LOCKPICK MODULE]\e[0m Legal use only. You agree you are authorized to scan this target."
read -p "Enter target IP or domain: " TARGET
read -p "Are you authorized to scan this? (yes/no): " LEGAL

if [[ "$LEGAL" != "yes" ]]; then
  echo "[LOCKPICK] Authorization not confirmed. Exiting."
  exit 1
fi

echo "[LOCKPICK] Scanning $TARGET..."
echo "Target: $TARGET" >> "$LOG_FILE"
date >> "$LOG_FILE"

# Basic recon: ping + whois + nmap
{
  echo -e "\n--- PING ---"
  ping -c 3 "$TARGET"
  echo -e "\n--- WHOIS ---"
  whois "$TARGET"
  echo -e "\n--- NMAP (Top 1000 ports) ---"
  nmap -T4 -F "$TARGET"
} >> "$LOG_FILE" 2>&1

echo -e "[LOCKPICK] Scan complete. Output saved to: $LOG_FILE"

