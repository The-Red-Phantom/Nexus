#!/bin/bash

user=$(whoami)
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | awk '/ether/ {print $2; exit}')
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
log_dir="$HOME/Nexus/logs/legal"
log_file="$log_dir/legal_usage.log"

mkdir -p "$log_dir"

log_entry="[$timestamp] USER: $user | IP: $ip | MAC: $mac | ACTION: Lockpick Access"
echo "$log_entry" >> "$log_file"

echo "[!] Legal Check: You must have written authorization to scan this target."
read -p "Do you have permission? (yes/no): " perm

if [[ "${perm,,}" != "yes" ]]; then
    echo "[-] Access denied."
    exit 1
fi
