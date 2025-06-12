#!/bin/bash

# Nexus API Bootstrap - AeonCore Integration

echo "[NEXUS API] Bootstrapping Nexus environment..."

# Set absolute paths
NEXUS_HOME="/home/nexus/Nexus"
COREOPS_DIR="/home/nexus/Nexus/coreops"
CONFIG_FILE="/home/nexus/Nexus/config.json"

# Validate config file
if [ -f "$CONFIG_FILE" ]; then
    echo "[NEXUS API] Loading config from $CONFIG_FILE"
    PROJECT_NAME=$(jq -r '.project_name' "$CONFIG_FILE")
    BUILD_TAG=$(jq -r '.build_tag' "$CONFIG_FILE")
    echo "[NEXUS API] Project: $PROJECT_NAME | Build: $BUILD_TAG"
else
    echo "[NEXUS API] ERROR: Config file not found at $CONFIG_FILE"
    exit 1
fi

# Echo system details
echo "[NEXUS API] Nexus Home: $NEXUS_HOME"
echo "[NEXUS API] CoreOps Directory: $COREOPS_DIR"
echo "[NEXUS API] Integration successful. Nexus is aware and online."

# (Optional) Call additional scripts or initialize services below
# /home/nexus/Nexus/coreops/ghost_toggle.sh
# /home/nexus/Nexus/coreops/resurrect_toggle.sh
