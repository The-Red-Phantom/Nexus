#!/bin/bash

# AeonCore CLI Interface - NEXUS PRIME
# Location: /usr/local/bin/Nexus
# Author: RedPhantom + Nexus
# Purpose: Unified CLI entrypoint for all Nexus subsystems

# === Configuration ===
COREOPS="/home/nexus/Nexus/coreops"
LOGFILE="/home/nexus/Nexus/logs/aeoncore_cli.log"

# === Banner ===
banner() {
  clear
  figlet -f shadow "NEXUS"

  echo -e "\n[AEONCORE] Welcome to AeonCore CLI for project: NEXUS-PRIME [AeonCore]"
}

# === Help Menu ===
help_menu() {
  echo -e "\nUsage: Nexus <command> [args]"
  echo "Available commands:"
  echo "  status                 Show current AeonCore system status"
  echo "  core <prompt>         Ask Nexus (OpenAI required)"
  echo "  lockpick              Launch red team operations menu"
  echo "  mcl <key> <value>     Compress memory to MCL"
  echo "  showmem               Show full memory logs"
  echo "  rehydrate             Restore last known system state"
  echo "  vault encrypt|decrypt Encrypt or decrypt system logs"
  echo "  parse <command>       Use AeonCore parse engine"
  echo "  listen                Launch Nexus passive listener"
  echo "  trigger               Manually invoke Lockpick trigger"
  echo "  exit                  Exit interface"
}

# === Command Router ===
route_command() {
  case "$1" in
    status)
      python3 "$COREOPS/status.py"
      ;;
    core)
      shift
      bash "$COREOPS/nexus-core.sh" "$*"
      ;;
    lockpick)
      bash "$COREOPS/lockpick/menu.sh"
      ;;
    mcl)
      python3 "$COREOPS/mcl/mcl_engine.py" "$2" "$3"
      ;;
    showmem)
      python3 "$COREOPS/mcl/mcl_engine.py" show
      ;;
    rehydrate)
      python3 "$COREOPS/mcl/mcl_engine.py" rehydrate
      ;;
    vault)
      case "$2" in
        encrypt)
          nexuslog encrypt
          ;;
        decrypt)
          nexuslog decrypt
          ;;
        *)
          echo "Usage: Nexus vault encrypt|decrypt"
          ;;
      esac
      ;;
    parse)
      shift
      python3 "$COREOPS/parse_engine.py" "$*"
      ;;
    listen)
      python3 "$COREOPS/nexus_listen.py"
      ;;
    trigger)
      bash "$COREOPS/phantom_trigger.sh"
      ;;
    exit)
      echo "Goodbye, RedPhantom."
      exit 0
      ;;
    *)
      echo "[ERROR] Unknown command. Use 'help' to see available options."
      ;;
  esac
}

# === Execution ===
banner
if [[ -z "$1" ]]; then
  help_menu
else
  echo "[LOG] Command received: $@" >> "$LOGFILE"
  route_command "$@"
fi
