#!/bin/bash

LOCKPICK_PATH="$HOME/Nexus/coreops/lockpick/menu.sh"
LOGDIR="$HOME/Nexus/logs/phantom"
mkdir -p "$LOGDIR"

echo "[PHANTOM] Lockpick operations accessed at: $(date)" >> "$LOGDIR/trigger.log"
bash "$LOCKPICK_PATH"
