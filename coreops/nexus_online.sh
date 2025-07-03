#!/bin/bash

# Path to MCL engine and Nexus status logger
MCL_ENGINE="$HOME/Nexus/coreops/mcl/mcl_engine.py"
STATUS="online"

echo "[NEXUS-ONLINE] Marking Nexus as ONLINE..."

# Log symbolic memory
python3 "$MCL_ENGINE" status "SilentCore:online"

# Optional system log marker
echo "[NEXUS] System marked online at $(date)"

exit 0
