#!/bin/bash
# nexus_online.sh - Master bootloader for Nexus AI

clear
echo "[NEXUS PRIME INITIATED] Booting core systems..."
echo "Timestamp: $(date)"
echo "User: $USER | Host: $(hostname)"

# Show current status
python3 /home/nexus/Nexus/coreops/status.py

# Start CLI
echo "[*] Launching AeonCore CLI..."
bash /home/nexus/Nexus/aeoncore_cli.sh

