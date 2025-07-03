#!/bin/bash

FLAG_PATH="$HOME/Nexus/coreops/.resurrect/resurrect_enabled"
LOG_PATH="$HOME/Nexus/logs/resurrect.log"
MCL_ENGINE="$HOME/Nexus/coreops/mcl/mcl_engine.py"

mkdir -p "$(dirname "$FLAG_PATH")"
mkdir -p "$(dirname "$LOG_PATH")"

if [[ -f "$FLAG_PATH" ]]; then
    rm "$FLAG_PATH"
    echo "[*] Resurrect mode deactivated at $(date)" >> "$LOG_PATH"
    echo "resurrect" "off" | xargs python3 "$MCL_ENGINE" 2>/dev/null
    echo "[+] Resurrect mode OFF (💤)"
else
    touch "$FLAG_PATH"
    echo "[*] Resurrect mode activated at $(date)" >> "$LOG_PATH"
    echo "resurrect" "on" | xargs python3 "$MCL_ENGINE" 2>/dev/null
    echo "[+] Resurrect mode ON (🔁)"
fi
