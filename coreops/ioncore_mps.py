import json
import psutil
import datetime
import sys
import os

log_path = os.path.expanduser("home/nexus/Nexus/logs/memory_log.json")

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

    os.makedirs(os.path.dirname(log_path), exist_ok=True)
    if not os.path.exists(log_path):
        with open(log_path, "w") as f:
            json.dump([], f)

    with open(log_path, "r+") as f:
        logs = json.load(f)
        logs.append(data)
        f.seek(0)
        json.dump(logs, f, indent=4)

if __name__ == "__main__":
    symbolic_input = sys.argv[1] if len(sys.argv) > 1 else None
    memory_parse(symbolic_input)

