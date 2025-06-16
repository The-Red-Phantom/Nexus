#!/bin/bash

clear
echo "=== Lockpick Red Team Ops ==="
echo "Select a tool to deploy:"
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
    ./scan.sh "$TARGET"
    ;;
  2)
    read -p "Target IP or domain: " TARGET
    ./exploit_suggest.sh "$TARGET"
    ;;
  3)
    sudo ./cloak.sh
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

