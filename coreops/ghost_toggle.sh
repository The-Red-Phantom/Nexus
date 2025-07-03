#!/bin/bash
# ghost_toggle.sh – Toggle stealth mode for AeonCore Lockpick

GHOST_FLAG="$HOME/Nexus/coreops/.ghost/ghost_enabled"

enable_ghost() {
  echo "[GHOST] Enabling stealth mode..."

  sudo iptables -F OUTPUT
  sudo iptables -F INPUT
  sudo iptables -F FORWARD

  sudo iptables -P OUTPUT DROP
  sudo iptables -P INPUT DROP
  sudo iptables -P FORWARD DROP

  sudo iptables -A INPUT -i lo -j ACCEPT
  sudo iptables -A OUTPUT -o lo -j ACCEPT
  sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT         # DNS
  sudo iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
  sudo iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
  sudo iptables -A OUTPUT -p tcp --syn -j ACCEPT              # SYN scan

  touch "$GHOST_FLAG"
  echo "[GHOST] Stealth mode enabled."
}

disable_ghost() {
  echo "[GHOST] Disabling stealth mode..."
  sudo iptables -F OUTPUT
  sudo iptables -F INPUT
  sudo iptables -F FORWARD
  sudo iptables -P OUTPUT ACCEPT
  sudo iptables -P INPUT ACCEPT
  sudo iptables -P FORWARD ACCEPT
  rm -f "$GHOST_FLAG"
  echo "[GHOST] Stealth mode disabled."
}

status_ghost() {
  if [ -f "$GHOST_FLAG" ]; then
    echo "[GHOST] Stealth mode is currently ENABLED."
  else
    echo "[GHOST] Stealth mode is currently DISABLED."
  fi
}

case "$1" in
  on)
    enable_ghost
    ;;
  off)
    disable_ghost
    ;;
  status)
    status_ghost
    ;;
  *)
    echo "Usage: $0 {on|off|status}"
    ;;
esac
