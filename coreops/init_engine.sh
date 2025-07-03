#!/bin/bash

# AeonCore - CoreOps/init_engine.sh
# Initializes AeonCore environment and core services

echo "[AeonCore] Initializing engine..."

# Define base paths
AEON_HOME="$HOME/Nexus"
CONFIG_PATH="$AEON_HOME/config.json"
LOG_PATH="$AEON_HOME/logs"
MODULES_PATH="$AEON_HOME/coreops"
GHOST_FLAG="$AEON_HOME/coreops/.ghost/ghost_enabled"

# Timestamp for logging
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
STARTUP_LOG="$LOG_PATH/startup_$NOW.log"

# Ensure logs directory exists
mkdir -p "$LOG_PATH"
touch "$STARTUP_LOG"
echo "[*] Startup log initialized at $NOW" >> "$STARTUP_LOG"

# Check config
if [[ -f "$CONFIG_PATH" ]]; then
    echo "[+] Config file located at $CONFIG_PATH" >> "$STARTUP_LOG"
else
    echo "[!] Config not found at $CONFIG_PATH" >> "$STARTUP_LOG"
    echo "Exiting."
    exit 1
fi

# Check module dir
if [[ ! -d "$MODULES_PATH" ]]; then
    echo "[!] Modules directory missing. Creating it..." >> "$STARTUP_LOG"
    mkdir -p "$MODULES_PATH"
fi

# Dependency check
echo "[*] Checking dependencies..." >> "$STARTUP_LOG"
DEPS=("curl" "jq" "netcat" "nmap" "python3" "bash")

for bin in "${DEPS[@]}"; do
    if ! command -v $bin &> /dev/null; then
        echo "[!] Missing dependency: $bin" >> "$STARTUP_LOG"
    else
        echo "[+] Found dependency: $bin" >> "$STARTUP_LOG"
    fi
done

# Ghost Mode awareness
if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] Ghost Mode active." | tee -a "$STARTUP_LOG"
else
    echo "[+] Ghost Mode not active." >> "$STARTUP_LOG"
fi

echo "[+] Engine initialization complete." | tee -a "$STARTUP_LOG"
echo "AeonCore is ready."

exit 0
