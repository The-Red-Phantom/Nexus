#!/bin/bash
set -e
NEXUS_HOME=~/nexus-core
LOG="$NEXUS_HOME/logs/nexus.log"
VAULT="$NEXUS_HOME/vault/vault.gpg"

echo "[NEXUS] Welcome, Red Phantom."

case "$1" in

	log)
		echo "$(date '+%Y-%m-%d %H:%M:%S') :: $2" >> "$LOG"
		echo "[+] Logged Entry."
		;;
	run)
		MODULE="$NEXUS_HOME/modules/$2.sh"
		if [ -f "$MODULE" ]; then
			bash "$MODULE"
		else
			echo "[-] Module $2 not found."
		fi
		;;

	encrypt)
		gpg -c "$LOG" && mv "$LOG.gpg" "$VAULT"
		echo "[+] Logs encrypted to vault."
		;;

	decrypt)
		if [ -f "$LOG" ]; then
			TIMESTAMP=$(date +%Y%m%d-%H%M%S)
			BACKUP="$LOG.bak-$TIMESTAMP"
			cp "$LOG" "$BACKUP"
			echo "[!] WARNING: Existing log found."
			echo "[+] Backup created at $BACKUP"

			gpg --decrypt "$VAULT" > "$LOG" && echo "[+] Vault decrypted to log." || echo "[!] Decryption failed."
		else
			echo "[-] Nothing to decrypt..... ya jackAss."
		fi
		;;

	*)
		echo "Usage:"
		echo " nexus.sh log \"note text\""
		echo " nexus.sh run <module>"
		echo " nexus.sh encrypt | decrypt"
		;;
	esac
