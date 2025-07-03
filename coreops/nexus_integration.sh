#!/bin/bash

# === Nexus Integration Script ===
echo -e "\n[NEXUS-INTEGRATION] Starting full system integration..."

NEXUS_DIR="/home/nexus/Nexus"
CLI_SCRIPT="/home/nexus/Nexus/aeoncore_cli.sh"
BIN_TARGET="/usr/local/bin/Nexus"
CONFIG_FILE="$NEXUS_DIR/config.json"
SYSTEMD_SERVICE="/etc/systemd/system/nexus.service"

# 1. Validate CLI exists
if [[ ! -f "$CLI_SCRIPT" ]]; then
  echo "[!] CLI script not found at: $CLI_SCRIPT"
  exit 1
fi

# 2. Make it executable
chmod +x "$CLI_SCRIPT"
echo "[\u2713] CLI script made executable."

# 3. Link to /usr/local/bin for global access
if [[ -L "$BIN_TARGET" || -f "$BIN_TARGET" ]]; then
  sudo rm -f "$BIN_TARGET"
fi
sudo ln -s "$CLI_SCRIPT" "$BIN_TARGET"
echo "[\u2713] Created global command: Nexus"

# 4. Validate dependencies
echo "[*] Checking required tools..."
MISSING=0
for cmd in python3 nmap curl openssl sqlite3 jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "[!] MISSING: $cmd"
    ((MISSING++))
  else
    echo "[\u2713] $cmd found"
  fi
done

if [[ "$MISSING" -gt 0 ]]; then
  echo "[!] Some dependencies are missing. Install them before continuing."
  exit 1
fi

# 5. Validate config.json
echo "[*] Validating config.json..."
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "[!] Missing config file: $CONFIG_FILE"
  exit 1
fi

# 6. Check OpenAI API key
OPENAI_KEY=$(jq -r '.openai_api_key' "$CONFIG_FILE")
if [[ -z "$OPENAI_KEY" || "$OPENAI_KEY" == "false" ]]; then
  echo "[!] OpenAI API key is missing or disabled in config.json"
else
  echo "[\u2713] OpenAI API key found. Testing connectivity..."

  # Lightweight API test
  RESPONSE=$(curl -s https://api.openai.com/v1/models \
    -H "Authorization: Bearer $OPENAI_KEY")

  if echo "$RESPONSE" | grep -q '"id":'; then
    echo "[\u2713] OpenAI API is responsive"
  else
    echo "[!] OpenAI API key may be invalid or quota exceeded"
  fi
fi

# 7. Optional: Register as a systemd service
read -p "[?] Register Nexus as a background service? (y/n): " svc
if [[ "$svc" == "y" ]]; then
  sudo bash -c "cat > $SYSTEMD_SERVICE" <<EOF
[Unit]
Description=Nexus Core Background Service
After=network.target

[Service]
ExecStart=$CLI_SCRIPT background
Restart=on-failure
User=$USER
WorkingDirectory=$NEXUS_DIR

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reexec
  sudo systemctl daemon-reload
  sudo systemctl enable nexus
  sudo systemctl start nexus
  echo "[\u2713] Nexus systemd service installed and started."
fi

echo -e "\n[\u2713] Integration complete. You can now type 'Nexus' from anywhere."
