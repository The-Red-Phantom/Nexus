#!/bin/bash

# AeonCore - CoreOps/init_engine.sh
# Initializes AeonCore environment and core services

echo "[AeonCore] Initializing engine..."

# Define base paths
AEON_HOME="/home/nexus/Nexus"
CONFIG_PATH="$AEON_HOME/config.json"
LOG_PATH="$AEON_HOME/Nexus/logs"
MODULES_PATH="$AEON_HOME/modules"
COREOPS_PATH="$AEON_HOME/coreops"

# Timestamp for logging
NOW=$(date +"%Y-%m-%d_%H-%M-%S")

# Ensure logs directory exists
mkdir -p "$LOG_PATH"

# Create startup log
touch "$LOG_PATH/startup_$NOW.log"
echo "[*] Startup log initialized at $NOW" >> "$LOG_PATH/startup_$NOW.log"

# Load config
if [[ -f "$CONFIG_PATH/aeoncore.conf" ]]; then
    source "$CONFIG_PATH"
    echo "[+] Config loaded." >> "$LOG_PATH/startup_$NOW.log"
else
    echo "[!] Config not found at $CONFIG_PATH" >> "$LOG_PATH/startup_$NOW.log"
    echo "Exiting."
    exit 1
fi

# Check and prepare module directory
if [[ ! -d "$MODULES_PATH" ]]; then
    echo "[!] Modules directory missing. Creating it..." >> "$LOG_PATH/startup_$NOW.log"
    mkdir -p "$MODULES_PATH"
fi

# Dependency check
echo "[*] Checking dependencies..." >> "$LOG_PATH/startup_$NOW.log"
DEPS=("curl" "jq" "netcat" "nmap" "python3" "bash")

for bin in "${DEPS[@]}"; do
    if ! command -v $bin &> /dev/null; then
        echo "[!] Missing dependency: $bin" >> "$LOG_PATH/startup_$NOW.log"
    else
        echo "[+] Found dependency: $bin" >> "$LOG_PATH/startup_$NOW.log"
    fi
done

echo "[+] Engine initialization complete." >> "$LOG_PATH/startup_$NOW.log"
echo "AeonCore is ready."

exit 0
