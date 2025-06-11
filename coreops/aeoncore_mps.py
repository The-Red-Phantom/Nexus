#!/usr/bin/env python3

import os
import psutil
import json
from datetime import datetime

def collect_memory_data():
    memory = psutil.virtual_memory()
    swap = psutil.swap_memory()

    return {
        "timestamp": datetime.now().isoformat(),
        "memory_total": memory.total,
        "memory_available": memory.available,
        "memory_used": memory.used,
        "memory_percent": memory.percent,
        "swap_total": swap.total,
        "swap_used": swap.used,
        "swap_percent": swap.percent
    }

def save_memory_report(output_path="~/Nexus/logs/memory_report.json"):
    try:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        data = collect_memory_data()

        with open(output_path, 'w') as f:
            json.dump(data, f, indent=4)
        print(f"[+] Memory report saved to {output_path}")

    except Exception as e:
        print(f"[-] Error saving memory report: {e}")

if __name__ == "__main__":
    save_memory_report()
