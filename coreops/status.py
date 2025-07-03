#!/usr/bin/env python3
# status.py — AeonCore status scan: ghost/resurrect state + system/env config

import os
import json
import platform
from datetime import datetime

CONFIG_PATH = "/home/nexus/Nexus/config.json"

def load_config():
    try:
        with open(CONFIG_PATH, 'r') as file:
            return json.load(file)
    except Exception as e:
        print(f"[ERROR] Failed to load config: {e}")
        return {}

def read_toggle_file(file_path):
    return "ENABLED" if os.path.isfile(file_path) else "DISABLED"

def main():
    config = load_config()
    if not config:
        return

    print("\033[1;36m[AEONCORE]\033[0m Welcome to AeonCore CLI for project: {} [{}]".format(
        config.get("project_name", "Unknown"),
        config.get("build_tag", "Unknown")
    ))

    print("\n🧠  AeonCore Status Report")
    print("🕒  Timestamp:      {}".format(datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
    print("💻  System:         {} {} | Node: {}".format(platform.system(), platform.release(), platform.node()))

    print("\n📁  CoreOps Path:   {}".format(config.get("coreops_path", "Not Defined")))
    print("🗂   Config Path:    {}".format(CONFIG_PATH))
    print("🔧  Project:        {}".format(config.get("project_name", "Unknown")))
    print("🔨  Build:          {}".format(config.get("build_tag", "Unknown")))

    ghost_flag = os.path.expanduser("~/Nexus/coreops/.ghost/ghost_enabled")
    resurrect_flag = os.path.expanduser("~/Nexus/coreops/.resurrect/resurrect_enabled")

    print("\n👻  Ghost Mode:     {}".format(read_toggle_file(ghost_flag)))
    print("☠️  Resurrect Mode: {}".format(read_toggle_file(resurrect_flag)))

    print("\n🧬  Memory Paths:")
    print("     log_dir:       {}".format(config.get("log_dir", "Not Defined")))
    print("     vault_dir:     {}".format(config.get("vault_dir", "Not Defined")))

    print("\n[✓] System status check complete.\n")

if __name__ == "__main__":
    main()
