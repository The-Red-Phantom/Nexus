#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

clear
figlet -f slant "LOCKPICK"
echo ""
echo "=== Lockpick Red Team Ops Launcher ==="
echo "System: $(hostname) | User: $USER | Time: $(date)"
if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE"
else
    echo "[+] Normal mode"
fi
echo ""
echo "1) Network Recon         (scan.sh)"
echo "2) Exploit Suggestions   (exploit_suggest.sh)"
echo "3) Cloak Identity        (cloak.sh)"
echo "4) Exit"
echo ""

read -p "Choice: " CHOICE

case $CHOICE in
  1)
    read -p "Target IP or domain: " TARGET
    "$SCRIPT_DIR/scan.sh" "$TARGET"
    ;;
  2)
    read -p "Target IP or domain: " TARGET
    "$SCRIPT_DIR/exploit_suggest.sh" "$TARGET"
    ;;
  3)
    sudo "$SCRIPT_DIR/cloak.sh"
    ;;
  4)
    echo "Exiting Lockpick..."
    exit 0
    ;;
  *)
    echo "Invalid option. Try again."
    sleep 1
    exec "$0"
    ;;
esac
