#!/bin/bash

# nexus-core.sh — Enhanced interface for Nexus backend

CORE_PATH="$HOME/Nexus/coreops"
CONFIG_PATH="$HOME/Nexus/config.json"
PYTHON_EXEC="$(which python3)"
ENGINE="$CORE_PATH/nexus_core.py"
MCL="$CORE_PATH/mcl/mcl_engine.py"
GHOST_FLAG="$CORE_PATH/.ghost/ghost_enabled"
RES_FLAG="$CORE_PATH/.resurrect/resurrect_enabled"

# Mode awareness
MODE_TAG=""
[[ -f "$GHOST_FLAG" ]] && MODE_TAG="[🫥 GHOST MODE] "
[[ -f "$RES_FLAG" ]] && MODE_TAG="[🔁 RESURRECT MODE] "

# Core check
if [[ ! -f "$ENGINE" ]]; then
  echo "[!] Core engine not found at $ENGINE"
  exit 1
fi

# Prompt input
if [[ -z "$1" ]]; then
  echo "[*] Usage: nexus-core.sh \"Your prompt here\""
  exit 0
fi

PROMPT="$*"
RESPONSE=$($PYTHON_EXEC "$ENGINE" "$PROMPT")

# Output with mode tag
echo -e "\n${MODE_TAG}[Nexus]: $RESPONSE"

# Compress to MCL memory
$PYTHON_EXEC "$MCL" "prompt:$PROMPT" "$RESPONSE" >/dev/null 2>&1 || echo "[!] MCL logging failed."
