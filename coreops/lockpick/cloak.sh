#!/bin/bash

# cloak.sh – Red Phantom Mode
# Changes hostname, MAC address, and clears logs for evasion

# Root check
if [[ $EUID -ne 0 ]]; then
    echo "[!] Must run as root."
    exit 1
fi

# Check for needed binaries
for cmd in hostnamectl ip journalctl; do
    if ! command -v $cmd &> /dev/null; then
        echo "[-] Required command not found: $cmd"
        exit 1
    fi
done

# Generate new hostname and MAC
NEW_HOST="cloak-$(head /dev/urandom | tr -dc a-f0-9 | head -c6)"
NEW_MAC=$(printf '02:%02x:%02x:%02x:%02x:%02x\n' \
    $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))

# Save current settings for potential revert
CUR_HOST=$(hostname)
CUR_MAC=$(ip link show $(ip route | grep default | awk '{print $5}') | awk '/ether/ {print $2}')
echo "$CUR_HOST" > /tmp/original_hostname
echo "$CUR_MAC" > /tmp/original_mac

# Set hostname
echo "[+] Setting hostname to $NEW_HOST"
hostnamectl set-hostname "$NEW_HOST"

# Set MAC address
IFACE=$(ip route | grep default | awk '{print $5}')
echo "[+] Spoofing MAC address on interface: $IFACE"
ip link set "$IFACE" down
ip link set "$IFACE" address "$NEW_MAC"
ip link set "$IFACE" up

# Confirm trail cleaning
read -p "[!] Wipe system trail logs? (yes/no): " wipe
if [[ "${wipe,,}" == "yes" ]]; then
    echo "[+] Cleaning basic system trails"
    > /var/log/wtmp
    > /var/log/btmp
    > /var/log/lastlog
    journalctl --rotate && journalctl --vacuum-time=1s
else
    echo "[-] Log cleaning skipped."
fi

echo "[✓] Cloaking complete. You are now: $NEW_HOST [$NEW_MAC]"

