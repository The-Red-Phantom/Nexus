#!/usr/bin/env python3

import json
import os
import platform
import datetime

CONFIG_PATH = os.path.expanduser('/home/nexus/Nexus/config.json')
COREOPS_PATH = os.path.expanduser('/home/nexus//Nexus/coreops')

def load_config():
    try:
        with open(CONFIG_PATH, 'r') as f:
            return json.load(f)
    except Exception as e:
        return {"error": f"Failed to load config: {str(e)}"}

def get_status():
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    system = platform.system()
    release = platform.release()
    node = platform.node()
    config = load_config()

    print("🧠 AeonCore Status Report")
    print(f"🕒 Timestamp: {now}")
    print(f"💻 System: {system} {release} | Node: {node}")
    print(f"📁 CoreOps Path: {COREOPS_PATH}")
    print(f"🗂️ Config Path: {CONFIG_PATH}")

    if "error" in config:
        print(f"⚠️ Config Error: {config['error']}")
        return

    print(f"🔧 Project: {config.get('project', 'Unknown')}")
    print(f"🔨 Build: {config.get('build', 'Unknown')}")
    print(f"👻 Ghost Mode: {'ENABLED' if config.get('ghost_mode') else 'DISABLED'}")
    print(f"☠️ Resurrection Mode: {'ENABLED' if config.get('resurrect_mode') else 'DISABLED'}")

    memory_paths = config.get("memory_paths", {})
    if memory_paths:
        print("🧬 Memory Paths:")
        for key, value in memory_paths.items():
            print(f"  {key}: {value}")

if __name__ == "__main__":
    get_status()
