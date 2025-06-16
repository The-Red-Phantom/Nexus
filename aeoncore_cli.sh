#!/bin/bash
# File: aeoncore_cli.sh
# Purpose: Main CLI interface for AeonCore/Nexus system

# Define core paths
CORE_DIR="/home/nexus/Nexus/coreops"
CONFIG_FILE="/home/nexus/Nexus/config.json"
VAULT_KEY="/home/nexus/Nexus/vault/nexus.key"
NEXUS_BRIDGE="/home/nexus/Nexus/coreops/nexus_bridge.py"
INIT_ENGINE="/home/nexus/Nexus/coreops/init_engine.sh"

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
    echo "  core               Run the Nexus Core directly"
    echo "  exit               Exit CLI"
}

# Function: Load Nexus
function nexus() {
    bash "$CORE_DIR/nexus_online.sh"
}

# Function: Initialize Engine
function init() {
    bash "$INIT_ENGINE"
}

# Function: Run MPS
function mps() {
    python3 "$CORE_DIR/ioncore_mps.py"
}

# Function: Toggle ghost mode
function "ghost"){
	if [[ "$2" == "on" || "$2" == "off" ]]; then
		sudo "$CORE_DIR/ghost_toggle,sh" "$2"
	else 
		echo =e "$(CYAN)[AEONCORE]$(NC) Usage: ghost [on:off]"
	fi
	;;

    bash "$CORE_DIR/ghost_toggle.sh"
}

# Function: Toggle resurrect mode
function resurrect() {
    bash "$CORE_DIR/resurrect_toggle.sh"
}

# Function: Show system status
function show_status() {
    python3 "$CORE_DIR/status.py"
}

# Function: Launch lockpick module
function lockpick() {
    bash "$CORE_DIR/phantomops/lockpick.sh"
}

# Function: Run Nexus Core
function core() {
    python3 "/home/nexus/Nexus/coreops/nexus_core.py"
}

# Main CLI loop
COMMAND="$1"

case $COMMAND in
    help)
        show_help
        ;;
    init)
        init
        ;;
    nexus)
        nexus
        ;;
    mps)
        mps
        ;;
    ghost)
        ghost
        ;;
    resurrect)
        resurrect
        ;;
    status)
        show_status
        ;;
    lockpick)
        lockpick
        ;;
    core)
        core
        ;;
    exit)
        echo "[AEONCORE] Exiting CLI."
        ;;
    *)
        echo "[ERROR] Unknown command. Use 'help' to see available options."
        ;;
esac

