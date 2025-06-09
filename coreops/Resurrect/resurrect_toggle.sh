#!/bin/bash

# resurrect_toggle.sh
# RedPhantom Protocol: Reverse GhostMode — Re-enable all interfaces and visibility

echo "[Resurrect Mode] Activating..."

# Bring up all network interfaces
for iface in $(ls /sys/class/net/); do
    sudo ip link set "$iface" up
done

# Enable ICMP responses
sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0

# Allow inbound and outbound traffic (reset iptables)
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F

echo "[Resurrect Mode] All systems visible and responsive. You’re back in the matrix."
