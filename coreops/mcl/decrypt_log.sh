#!/bin/bash

# PhantomOps: Secure Decryption Utility
# Usage: ./decrypt_log.sh <encrypted_file>

ENCFILE="$1"
KEYFILE="$HOME/Nexus/coreops/vault/nexus.key"
OUTDIR="$HOME/Nexus/logs/decrypted"

mkdir -p "$OUTDIR"

if [[ ! -f "$ENCFILE" ]]; then
  echo "[ERROR] Encrypted file not found."
  exit 1
fi

if [[ ! -f "$KEYFILE" ]]; then
  echo "[ERROR] Key not found at $KEYFILE"
  exit 1
fi

BASENAME=$(basename "$ENCFILE" .enc)
OUTFILE="$OUTDIR/$BASENAME"

# Decrypt with AES-256-CBC
openssl enc -d -aes-256-cbc -in "$ENCFILE" -out "$OUTFILE" -pass file:"$KEYFILE"

if [[ $? -eq 0 ]]; then
  echo "[✓] Decryption complete: $OUTFILE"
  
  # Auto-view file
  echo "[*] Displaying decrypted log..."
  echo "----------------------------------"
  cat "$OUTFILE"
  echo "----------------------------------"
  
  # Ask if user wants to remove encrypted file
  read -p "[?] Delete original encrypted file? (y/N): " choice
  case "$choice" in
    y|Y ) shred -u "$ENCFILE" && echo "[+] Encrypted file removed." ;;
    * ) echo "[i] Encrypted file retained at $ENCFILE" ;;
  esac
else
  echo "[!] Decryption failed."
fi
