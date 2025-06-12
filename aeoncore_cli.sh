#!/bin/bash

# AeonCore CLI | Nexus Interface Layer
CONFIG_FILE="/home/nexus/Nexus/config.json"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "❌ config.json not found!"
  exit 1
fi

PROJECT=$(jq -r ".project" "$CONFIG_FILE")
BUILD=$(jq -r ".build" "$CONFIG_FILE")
COREOPS_DIR="/home/nexus/Nexus/coreops"
VERSION="1.0"

banner() {
  clear
  echo -e "\e[1;31m"
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║     🧠 AeonCore Nexus CLI v$VERSION — SYSTEM ONLINE       ║"
  echo "╠══════════════════════════════════════════════════════╣"
  echo -e "║  🔧 Project: \e[1;36m$PROJECT\e[1;31m | Build: \e[1;36m$BUILD\e[1;31m ║"
  echo "║  👁  Ghostline Monitor Active — Welcome back, Red.  ║"
  echo "║  📡 Listening for anomalies across digital æther...   ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo -e "\e[0m"
}


show_help() {
  echo -e "\nUsage: aeoncore_cli.sh [option]"
  echo "  --status        Show current AeonCore system status"
  echo "  --ghost         Toggle Ghost Mode (calls ghost_toggle.sh)"
  echo "  --resurrect     Toggle Resurrection Mode (calls resurrect_toggle.sh)"
  echo "  --vault         Open vault menu (calls vault_menu.sh if exists)"
  echo "  --mps           Run Memory Parser (aeoncore_mps.py)"
  echo "  --help          Show this help menu"
}

check_and_run() {
  local script="$1"
  if [[ -f "$script" ]]; then
    echo "⚙️ Launching $(basename $script)..."
    bash "$script"
  else
    echo "❌ Module not found: $(basename $script)"
  fi
}

case "$1" in
  --status)
    banner
    echo "🔍 System Paths:"
    echo "  CoreOps: $COREOPS_DIR"
    echo "  Config: $CONFIG_FILE"
    ;;
  --ghost)
    check_and_run "$COREOPS_DIR/ghost_toggle.sh"
    ;;
  --resurrect)
    check_and_run "$COREOPS_DIR/resurrect_toggle.sh"
    ;;
  --vault)
    check_and_run "$COREOPS_DIR/vault_menu.sh"
    ;;
  --mps)
    python3 "$COREOPS_DIR/aeoncore_mps.py"
    ;;
  --help | *)
    banner
    show_help
    ;;
esac

