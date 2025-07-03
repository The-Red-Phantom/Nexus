#!/bin/bash

echo "[+] Activating Ghost Mode..."

# Flush existing rules first
sudo iptables -F

# Default DROP policies
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# Allow loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Block ICMP (ping)
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

# Mark ghost mode as active
touch "$HOME/Nexus/coreops/.ghost/ghost_active"

echo "[+] Ghost Mode Initiated. You are now invisible to the world."

exit 0
