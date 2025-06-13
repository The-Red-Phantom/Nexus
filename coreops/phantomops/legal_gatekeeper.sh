#!/bin/bash
user=$(whoami)
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | awk '/ether/ {print $2; exit}')
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
log_entry="[$timestamp] USER: $user | IP: $ip | MAC: $mac | ACTION: Lockpick Access"

echo "$log_entry" >> /home/nexus/Nexus/logs/legal/legal_usage.log
echo "[!] Legal Check: You must have written authorization to scan this target."
read -p "Do you have permission? (yes/no): " perm
[[ "$perm" != "yes" ]] && echo "[-] Access denied." && exit 1
