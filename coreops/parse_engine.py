#!/usr/bin/env python3

import os
import json
import datetime
import sys

CONFIG_PATH = "/home/nexus/Nexus/config.json"
LOG_PATH = "/home/nexus/Nexus/logs/ioncore.log"

def log_event(message):
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(LOG_PATH, 'a') as log:
        log.write(f"[{timestamp}] {message}\n")

def load_config():
    try:
        with open(CONFIG_PATH, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        log_event("[ERROR] Config file not found.")
        return {}
    except json.JSONDecodeError as e:
        log_event(f"[ERROR] JSON parsing failed: {e}")
        return {}

def parse_command(command):
    config = load_config()
    if not config:
        return "[ERROR] Failed to load configuration."

    if command == "status":
        modules = ", ".join(config.get("modules", []))
        return f"AeonCore Status: ONLINE\nModules Loaded: {modules}"
    elif command == "whoami":
        return f"Identity: {config.get('identity', 'unknown')}"
    elif command == "logtest":
        log_event("Test log entry from parse_command()")
        return "Log entry written successfully."
    else:
        return f"[UNKNOWN COMMAND] '{command}' not recognized."

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = " ".join(sys.argv[1:])
        print(parse_command(cmd))
    else:
        print("Usage: parse_engine.py <command>")
