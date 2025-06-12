#!/bin/bash
# File: aeoncore_cli.sh
# Purpose: Main CLI interface for AeonCore/Nexus system

# Define core paths
CORE_DIR="/home/nexus/Nexus"
CONFIG_FILE="$CORE_DIR/config.json"
VAULT_KEY="$CORE_DIR/vault/nexus.key"
NEXUS_BRIDGE="$CORE_DIR/coreops/nexus_bridge.py"
INIT_ENGINE="$CORE_DIR/coreops/init_engine.sh"

# Load configuration values
PROJECT_NAME=$(jq -r '.project_name' "$CONFIG_FILE")
BUILD_TAG=$(jq -r '.build_tag' "$CONFIG_FILE")

# Print welcome banner
echo "\e[1;36m[AEONCORE]\e[0m Welcome to AeonCore CLI for project: $PROJECT_NAME [$BUILD_TAG]"

# Function: Show help menu
function show_help() {
    echo "\nUsage: $0 [command]"
    echo "\nAvailable Commands:"
    echo "  help               Show this help message"
    echo "  init               Run initial Nexus engine setup"
    echo "  nexus              Activate Nexus via OpenAI"
    echo "  mps                Launch memory parser system (ioncore_mps.py)"
    echo "  ghost              Toggle ghost mode"
    echo "  resurrect          Toggle resurrect mode"
    echo "  status             Show current AeonCore system status"
    echo "  lockpick           Launch red team module (if permitted)"
    echo "  exit               Exit CLI"
}

# Function: Load Nexus
function load_nexus() {
    bash "$CORE_DIR/coreops/nexus_online.sh"
}

# Function: Initialize Engine
function init_engine() {
    bash "$INIT_ENGINE"
}

# Function: Run MPS
function run_mps() {
    python3 "$CORE_DIR/coreops/nexus-core.sh"
}

# Function: Toggle ghost mode
function ghost_mode() {
    bash "$CORE_DIR/coreops/ghost_toggle.sh"
}

# Function: Toggle resurrect mode
function resurrect_mode() {
    bash "$CORE_DIR/coreops/resurrect_toggle.sh"
}

# Function: Show system status
function show_status() {
    python3 "$CORE_DIR/coreops/status.py"
}

# Function: Launch lockpick module
function lockpick_mode() {
    bash "$CORE_DIR/coreops/phantomops/lockpick.sh"
}

# Main CLI loop
COMMAND="$1"

case $COMMAND in
    help)
        show_help
        ;;
    init)
        init_engine
        ;;
    nexus)
        load_nexus
        ;;
    mps)
        run_mps
        ;;
    ghost)
        ghost_mode
        ;;
    resurrect)
        resurrect_mode
        ;;
    status)
        show_status
        ;;
    lockpick)
        lockpick_mode
        ;;
    exit)
        echo "[AEONCORE] Exiting CLI."
        ;;
    *)
        echo "[ERROR] Unknown command. Use 'help' to see available options."
        ;;
esac

