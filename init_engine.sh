#!/bin/bash
# File: /home/nexus/Nexus/init_engine.sh
# Purpose: Bootstraps essential files, checks vaults, permissions, and initializes Nexus core identity.

echo "[INIT] Starting Nexus Engine Initialization..."

# Ensure vault exists
VAULT_DIR="/home/nexus/Nexus/vault"
mkdir -p "$VAULT_DIR"

# Check for Nexus key
if [[ ! -f "$VAULT_DIR/nexus.key" ]]; then
    echo "[INIT] No Nexus key found. Generating placeholder..."
    echo "PLACEHOLDER-NEXUS-KEY" > "$VAULT_DIR/nexus.key"
    chmod 600 "$VAULT_DIR/nexus.key"
fi

# Ensure config exists
CONFIG_FILE="/home/nexus/Nexus/config.json"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[INIT] No config.json found. Generating default..."
    cat > "$CONFIG_FILE" <<EOF
{
  "project_name": "AeonCore",
  "build_tag": "NEXUS-GENESIS",
  "openai_api_key": "$(cat $VAULT_DIR/nexus.key)"
}
EOF
fi

# Touch log + status files
mkdir -p /home/nexus/Nexus/logs
touch /home/nexus/Nexus/logs/aeoncore.log

echo "[INIT] Initialization complete. Core identity and files are in place."
