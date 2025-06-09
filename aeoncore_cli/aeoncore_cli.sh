#!/bin/bash

# AeonCore CLI – RedPhantom Interface
# Entry point for executing AeonCore modules

AEON_PATH="$(dirname "$(realpath "$0")")"
CORE_PATH="$AEON_PATH/core"
CONFIG_PATH="$AEON_PATH/config"
LOG_PATH="$AEON_PATH/logs"

show_help() {
  echo "AeonCore Command Line Interface"
  echo ""
  echo "Usage: aeoncore_cli.sh [command]"
  echo ""
  echo "Commands:"
  echo "  mps         Run Memory Parser System"
  echo "  ghost       Activate Ghost Mode"
  echo "  resurrect   Deactivate Ghost Mode (restore full visibility)"
  echo "  log         View system logs"
  echo "  status      System status overview"
  echo "  help        Display this help message"
  echo ""
}

case "$1" in
  mps)
    bash "$CORE_PATH/mps.sh"
    ;;
  ghost)
    bash "$CORE_PATH/ghostmode.sh"
    ;;
  resurrect)
    bash "$CORE_PATH/resurrect.sh"
    ;;
  log)
    bash "$CORE_PATH/log.sh"
    ;;
  status)
    bash "$CORE_PATH/status.sh"
    ;;
  help|"")
    show_help
    ;;
  *)
    echo "[!] Unknown command: $1"
    show_help
    exit 1
    ;;
esac
