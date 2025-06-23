#!/usr/bin/env python3
# File: status.py
# Purpose: Show AeonCore system status including ghost/resurrect states, timestamps, and memory paths

import os
import json
import platform
from datetime import datetime

CONFIG_PATH = ("/home/nexus/Nexus/config.json")

def load_config(path):
    try:
        with open(path, 'r') as file:
            return json.load(file)
    except Exception as e:
        print(f"[ERROR] Failed to load config: {e}")
        return {}

def read_toggle_file(file_path):
    try:
        with open(file_path, 'r') as f:
            return f.read().strip().upper()
    except:
        return "DISABLED"

def main():
    config = load_config(CONFIG_PATH)
    if not config:
        return

    print("\033[1;36m[AEONCORE]\033[0m Welcome to AeonCore CLI for project: {} [{}]".format(
        config.get("project_name", "Unknown"),
        config.get("build_tag", "Unknown")
    ))

    print("🧠 AeonCore Status Report")
    print("🕒 Timestamp:", datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    print("💻 System:", platform.system(), platform.release(), "| Node:", platform.node())

    print("📁 CoreOps Path:", config.get("coreops_path", "Not Defined"))
    print("🗂 Config Path:", CONFIG_PATH)
    print("🔧 Project:", config.get("project_name", "Unknown"))
    print("🔨 Build:", config.get("build_tag", "Unknown"))

    ghost_status = read_toggle_file("/home/nexus/Nexus/coreops/.ghost")
    resurrect_status = read_toggle_file("/home/nexus/Nexus/coreops/.resurrect")

    print("👻 Ghost Mode:", ghost_status)
    print("☠ Resurrection Mode:", resurrect_status)

    print("🧬 Memory Paths:")
    print("  log_dir:", config.get("log_dir", "Not Defined"))
    print("  vault_dir:", config.get("vault_dir", "Not Defined"))

if __name__ == "__main__":
    main()
