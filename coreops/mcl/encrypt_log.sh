#!/bin/bash

# Encrypt a file using AES-256-CBC
# Usage: ./encrypt_log.sh <logfile>

INFILE="$1"
KEYFILE="$HOME/Nexus/coreops/vault/nexus.key"
OUTDIR="$HOME/Nexus/coreops/vault/encrypted"

mkdir -p "$OUTDIR"

if [[ ! -f "$INFILE" ]]; then
  echo "[ERROR] Input file not found."
  exit 1
fi

if [[ ! -f "$KEYFILE" ]]; then
  echo "[ERROR] Encryption key not found at $KEYFILE"
  exit 1
fi

BASENAME=$(basename "$INFILE")
openssl enc -aes-256-cbc -salt -in "$INFILE" -out "$OUTDIR/${BASENAME}.enc" -pass file:"$KEYFILE"

if [[ $? -eq 0 ]]; then
  echo "[+] Encrypted: $OUTDIR/${BASENAME}.enc"
  shred -u "$INFILE" 2>/dev/null
else
  echo "[!] Encryption failed."
fi
