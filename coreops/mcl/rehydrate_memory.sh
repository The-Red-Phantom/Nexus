#!/bin/bash

echo "[MCL INIT] Rehydrating Nexus memory..." >> ~/Nexus/logs/mcl_boot.log
python3 ~/Nexus/coreops/mcl/mcl_engine.py rehydrate >> ~/Nexus/logs/mcl_boot.log 2>&1
