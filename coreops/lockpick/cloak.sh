#!/bin/bash

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo "[!] Must run as root."
    exit 1
fi

# Random hostname and MAC generator
NEW_HOST="cloak-$(head /dev/urandom | tr -dc a-f0-9 | head -c6)"
NEW_MAC="$(printf '02:%02X:%02X:%02X:%02X:%02X\n' $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM)"

echo "[+] Setting hostname to $NEW_HOST"
hostnamectl set-hostname "$NEW_HOST"

echo "[+] Spoofing MAC address"
IFACE=$(ip route | grep default | awk '{print $5}')
ip link set "$IFACE" down
ip link set "$IFACE" address "$NEW_MAC"
ip link set "$IFACE" up

# Optional: clean system trails (lightweight)
echo "[+] Cleaning basic system trails"
> /var/log/wtmp
> /var/log/btmp
> /var/log/lastlog
journalctl --rotate && journalctl --vacuum-time=1s

echo "[+] Cloaking complete. You are now a ghost: $NEW_HOST [$NEW_MAC]"
