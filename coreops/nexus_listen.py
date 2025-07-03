#!/usr/bin/env python3

import time
import json
import os
import subprocess
from datetime import datetime

CONFIG_PATH = "/home/nexus/Nexus/config.json"
TRIGGER_PHRASE = "wake nexus"  # can change to more stealthy signal
LISTEN_LOG = "/home/nexus/Nexus/logs/nexus_listen.log"

def load_config():
    try:
        with open(CONFIG_PATH, "r") as f:
            return json.load(f)
    except Exception as e:
        log(f"[ERROR] Failed to load config: {e}")
        return {}

def log(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LISTEN_LOG, "a") as f:
        f.write(f"[{timestamp}] {message}\n")
    print(f"[NEXUS LISTEN] {message}")

def listen_loop():
    log("Nexus passive listener initialized.")
    try:
        while True:
            time.sleep(2)
            # Placeholder for input source — could be mic, file, socket, etc.
            # Simulating with a local file for now
            try:
                with open("/tmp/nexus_trigger.txt", "r") as f:
                    content = f.read().strip().lower()
                    if TRIGGER_PHRASE in content:
                        log(f"Trigger detected: {content}")
                        subprocess.Popen(["/home/nexus/Nexus/coreops/nexus-core.sh", "System online."])
                        os.remove("/tmp/nexus_trigger.txt")  # clear trigger
            except FileNotFoundError:
                pass
    except KeyboardInterrupt:
        log("Listener terminated by user.")

if __name__ == "__main__":
    listen_loop()
