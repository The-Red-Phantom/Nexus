#!/bin/bash
set -e

NEXUS_HOME="$HOME/Nexus"
LOG="$NEXUS_HOME/logs/nexus.log"
VAULT="$NEXUS_HOME/vault/vault.gpg"

echo "[NEXUS] Welcome, Red Phantom."

case "$1" in

    log)
        [[ -z "$2" ]] && { echo "[-] No log message provided."; exit 1; }
        mkdir -p "$(dirname "$LOG")"
        echo "$(date '+%Y-%m-%d %H:%M:%S') :: $2" >> "$LOG"
        echo "[+] Logged entry: $2"
        ;;

    run)
        MODULE="$NEXUS_HOME/modules/$2.sh"
        if [[ -f "$MODULE" ]]; then
            echo "[*] Running module: $2"
            bash "$MODULE"
        else
            echo "[-] Module '$2' not found in modules/"
        fi
        ;;

    encrypt)
        KEYFILE="$NEXUS_HOME/vault/nexus.gpg.key"
        if [[ -f "$LOG" ]]; then
            if [[ -f "$KEYFILE" ]]; then
                if gpg --batch --yes --passphrase-file "$KEYFILE" -c "$LOG"; then
                    mv "$LOG.gpg" "$VAULT"
                    shred -u "$LOG"
                    echo "[+] Logs encrypted to vault using keyfile."
                else
                    echo "[-] Encryption failed."
                fi
            else
                echo "[-] Keyfile not found at $KEYFILE."
            fi
        else
            echo "[-] No log found to encrypt."
        fi
        ;;

    decrypt)
        if [[ -f "$VAULT" ]]; then
            TIMESTAMP=$(date +%Y%m%d-%H%M%S)
            BACKUP="$LOG.bak-$TIMESTAMP"
            [[ -f "$LOG" ]] && cp "$LOG" "$BACKUP" && echo "[!] Backup of current log saved as $BACKUP"
            gpg --decrypt "$VAULT" > "$LOG" && echo "[+] Vault decrypted to log."
        else
            echo "[-] No vault file to decrypt, ya jackass."
        fi
        ;;

    *)
        echo "Usage:"
        echo "  nexus.sh log \"note text\""
        echo "  nexus.sh run <module>"
        echo "  nexus.sh encrypt | decrypt"
        ;;
esac
