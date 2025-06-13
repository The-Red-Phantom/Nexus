#!/bin/bash

TARGET=$1
if [[ -z "$TARGET" ]]; then
  echo "Usage: lockpick.sh <target-ip>"
  exit 1
fi

# 🕵️ Require Ghost Mode
bash /home/nexus/Nexus/coreops/ghost_toggle.sh status | grep -q "ACTIVE" || {
  echo "⚠️  Ghost Mode must be ACTIVE to run Lockpick. Exiting."
  exit 1
}

# ⚖️ Legal Log and Confirmation
bash /home/nexus/Nexus/coreops/phantomops/legal_gatekeeper.sh || exit 1

# 📁 Create Log Directory
LOG_DIR="/home/nexus/Nexus/logs/phantom/$TARGET"
mkdir -p "$LOG_DIR"

# 🧠 Nmap Vulnerability Scan
nmap -sV --script vuln -oN "$LOG_DIR/nmap_vuln.log" "$TARGET"

# 🧬 Extract CVEs
CVES=$(grep -oE 'CVE-[0-9]{4}-[0-9]+' "$LOG_DIR/nmap_vuln.log" | sort -u)

# 🛠️ Exploit Suggestion
python3 /home/nexus/Nexus/coreops/phantomops/exploit_suggester.py $CVES > "$LOG_DIR/exploits.txt"

# 🔐 Encrypt Logs
tar czf - "$LOG_DIR" | openssl enc -aes-256-cbc -salt -out "$LOG_DIR.tar.gz.enc" -k "AeonKeyX1337"

# 🧹 Clean up unencrypted logs
rm -rf "$LOG_DIR"

echo "[+] Lockpick complete. Encrypted logs saved to $LOG_DIR.tar.gz.enc"

