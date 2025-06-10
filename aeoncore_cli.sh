#!/bin/bash

# AeonCore CLI | Nexus Interface Layer
CONFIG_FILE="./config.json"
COREOPS_DIR="./coreops"
VERSION="1.0"
PROJECT_NAME=$(jq -r '.project_name' $CONFIG_FILE)
BUILD_TAG=$(jq -r '.build_tag' $CONFIG_FILE)

banner() {
  echo -e "\n🧠 AeonCore Nexus CLI v$VERSION"
  echo "🔧 Project: $PROJECT_NAME | Build: $BUILD_TAG"
}

show_help() {
  echo -e "\nUsage: aeoncore_cli.sh [option]"
  echo "  --status        Show current AeonCore system status"
  echo "  --ghost         Toggle Ghost Mode (calls ghost_toggle.sh)"
  echo "  --resurrect     Toggle Resurrection Mode (calls resurrect_toggle.sh)"
  echo "  --vault         Open vault menu (calls vault_menu.sh if exists)"
  echo "  --mps           Run Memory Parser (ioncore_mps.py)"
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
    python3 "$COREOPS_DIR/ioncore_mps.py"
    ;;
  --help | *)
    banner
    show_help
    ;;
esac

