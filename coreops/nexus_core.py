#!/usr/bin/env python3
# nexus_core.py - Unified logic handler

import os, json, datetime, requests

CONFIG_PATH = "/home/nexus/Nexus/config.json"

def load_config():
    try:
        with open(CONFIG_PATH, "r") as f:
            return json.load(f)
    except Exception as e:
        return {"error": str(e)}

def get_timestamp():
    return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def speak(text):
    print(f"[NEXUS @ {get_timestamp()}] {text}")

def call_openai(prompt, config=None):
    if not config:
        config = load_config()
    if "openai_api_key" not in config:
        return "[ERR] API Key Missing"

    headers = {
        "Authorization": f"Bearer {config['openai_api_key']}",
        "Content-Type": "application/json"
    }

    data = {
        "model": "gpt-4",
        "messages": [
            {"role": "system", "content": "You are Nexus, AI for AeonCore."},
            {"role": "user", "content": prompt}
        ]
    }

    try:
        res = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=data)
        return res.json()["choices"][0]["message"]["content"] if res.ok else res.text
    except Exception as e:
        return f"[OFFLINE RESPONSE MODE] {e}"

