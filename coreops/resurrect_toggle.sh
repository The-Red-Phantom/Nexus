#!/bin/bash

echo "[+] Beginning Resurrection...."

# Reset to accept everything (aka visible again)
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT

# Flush all rules
sudo iptables -F

echo "[+] Resurrection Successful! Welcome back to the land of the living!"

