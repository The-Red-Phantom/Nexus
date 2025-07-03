#!/bin/bash

LOOT_DIR="$HOME/Nexus/loot"
LOG_DIR="$HOME/Nexus/logs/lockpick"
TMP_DIR="/tmp"
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT="$LOOT_DIR/loot_summary_$NOW.txt"

mkdir -p "$LOOT_DIR"
echo "=== Lockpick Loot Summary ===" > "$REPORT"
echo "Timestamp: $NOW" >> "$REPORT"
echo "=============================" >> "$REPORT"

# Scan and collect log artifacts
echo -e "\n[+] Scanning logs in: $LOG_DIR and $TMP_DIR" >> "$REPORT"

# Copy relevant logs to loot dir
for f in "$LOG_DIR"/* "$TMP_DIR"/lockpick_*; do
  if [[ -f "$f" ]]; then
    cp "$f" "$LOOT_DIR/" 2>/dev/null
    echo "[+] Looted: $(basename "$f")" >> "$REPORT"
  fi
done

# Summary
echo -e "\n[+] Categorizing loot..." >> "$REPORT"

echo -e "\n--- Open Ports ---" >> "$REPORT"
grep -H "open" "$LOOT_DIR"/lockpick_scan_* 2>/dev/null | tee -a "$REPORT"

echo -e "\n--- Vulnerabilities ---" >> "$REPORT"
grep -H "VULNERABLE:" "$LOOT_DIR"/lockpick_vulnscan_* 2>/dev/null | tee -a "$REPORT"

echo -e "\n--- Creds / Anonymous Access ---" >> "$REPORT"
grep -H "Anonymous" "$LOOT_DIR"/lockpick_credcheck_* 2>/dev/null | tee -a "$REPORT"

echo -e "\n--- Recon Data ---" >> "$REPORT"
grep -H "TTL\|Banner\|Traceroute" "$LOOT_DIR"/lockpick_recon_* 2>/dev/null | tee -a "$REPORT"

echo -e "\n[✓] Loot summary saved to: $REPORT"
