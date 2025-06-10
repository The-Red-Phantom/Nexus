!#/usr/bin/env python3

import os
import json
import datetime

CONFIG_PATH = "/home/nexus/AeonCore/config/config.json"
LOG_PATH = "/home/nexus/AeonCore/logs/ioncore.log"

def load_config():
    try:
        with open(CONFIG_PATH, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        log_event("Config file not found.")
        return {}
    except json.JSONDecodeError as e:
        log_event(f"Error parsing config: {e}")
        return {}

def log_event(message):
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(LOG_PATH, 'a') as log:
        log.write(f"[{timestamp}] {message}\n")

def parse_command(command):
    config = load_config()
    response = f"Received command: {command}"

    if command == "status":
        response = f"AeonCore Status: Online\nModules Loaded: {', '.join(config.get('modules', []))}"
    elif command == "whoami":
        response = f"Identity: {config.get('identity', 'unknown')}"
    elif command == "logtest":
        log_event("Test log entry from parse_command()")
        response = "Log entry added."
    else:
        response = f"Unknown command: {command}"

    return response

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        cmd = " ".join(sys.argv[1:])
        print(parse_command(cmd))
    else:
        print("No command provided. Usage: parse_engine.py [command]")
