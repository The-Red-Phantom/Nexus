#!/bin/bash

echo "[+] Activating Ghost Mode..."

# Drop all inbound and outbound traffic by default
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# Allow traffic on loopbck so system doesn't choke
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Block ICMP (ping)
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

# Flush any open sessions
sudo iptables -F

# Make it stick for the session
echo "[+] Ghost Mode Initiated! You're a phantom!"

exit 0
