import json
import psutil
import datetime
import sys
import os

# Correct log path using user home
log_path = os.path.expanduser("~/Nexus/logs/memory_log.json")

def memory_parse(symbolic=None):
    memory = psutil.virtual_memory()
    swap = psutil.swap_memory()

    data = {
        "timestamp": str(datetime.datetime.now()),
        "memory_total": memory.total,
        "memory_available": memory.available,
        "memory_used": memory.used,
        "memory_percent": memory.percent,
        "swap_total": swap.total,
        "swap_used": swap.used,
        "swap_percent": swap.percent
    }

    if symbolic:
        data["symbolic_memory"] = symbolic

    try:
        os.makedirs(os.path.dirname(log_path), exist_ok=True)
        
        # Initialize file if missing
        if not os.path.exists(log_path):
            with open(log_path, "w") as f:
                json.dump([], f)

        # Append new entry to log
        with open(log_path, "r+") as f:
            try:
                logs = json.load(f)
            except json.JSONDecodeError:
                logs = []
            logs.append(data)
            f.seek(0)
            json.dump(logs, f, indent=4)

        print("[+] Memory log updated.")

    except Exception as e:
        print(f"[-] Error writing memory log: {e}")

if __name__ == "__main__":
    symbolic_input = sys.argv[1] if len(sys.argv) > 1 else None
    memory_parse(symbolic_input)
