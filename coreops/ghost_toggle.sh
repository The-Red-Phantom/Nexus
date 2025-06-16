#!/bin/bash
# ghost_toggle.sh: Toggle stealth mode for AeonCore Lockpick
# When enabled, block all outbound except essential scanning traffic

GHOST_FLAG="/tmp/ghost_mode.enabled"

enable_ghost() {
  echo "[GHOST] Enabling stealth mode..."
  # Flush existing rules to avoid conflicts
  iptables -F OUTPUT
  iptables -F INPUT
  iptables -F FORWARD

  # Default policies: block outbound and inbound
  iptables -P OUTPUT DROP
  iptables -P INPUT DROP
  iptables -P FORWARD DROP

  # Allow loopback and established connections
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Allow DNS (UDP 53) outbound for scans to resolve domains
  iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

  # Allow ICMP echo requests and replies (ping) outbound/inbound
  iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
  iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

  # Allow nmap TCP scanning on ports commonly used (e.g., top 1000)
  # Accept outbound TCP SYN packets (scan probes)
  iptables -A OUTPUT -p tcp --syn -j ACCEPT

  # Save flag file
  touch "$GHOST_FLAG"
  echo "[GHOST] Stealth mode enabled."
}

disable_ghost() {
  echo "[GHOST] Disabling stealth mode..."
  iptables -F OUTPUT
  iptables -F INPUT
  iptables -F FORWARD
  iptables -P OUTPUT ACCEPT
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
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

