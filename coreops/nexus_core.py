#!/usr/bin/env python3
# File: nexus_core.py
# Purpose: Central logic handler for Nexus in AeonCore

import os
import json
import datetime
import requests
import subprocess

CONFIG_PATH = "/home/nexus/Nexus/config.json"

def load_config():
    with open(CONFIG_PATH, "r") as f:
        return json.load(f)

def get_timestamp():
    return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def speak(message):
    print(f"[NEXUS] {message}")

def call_openai(prompt, config):
    headers = {
        "Authorization": f"Bearer {config['openai_api_key']}",
        "Content-Type": "application/json"
    }
    data = {
        "model": "gpt-4",
        "messages": [
            {"role": "system", "content": "You are Nexus, the AeonCore AI."},
            {"role": "user", "content": prompt}
        ]
    }
    try:
        res = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=data)
        if res.status_code == 200:
            return res.json()["choices"][0]["message"]["content"]
        else:
            return f"OpenAI error: {res.text}"
    except Exception as e:
        return f"[Offline] {str(e)}"

def local_think(prompt):
    return f"[LOCAL] Echoing: {prompt}"

def main():
    config = load_config()
    speak("Nexus Core Initialized")
    
    while True:
        user_input = input("nexus> ").strip()
        if user_input in ("exit", "quit"):
            speak("Powering down.")
            break
        elif user_input == "":
            continue
        elif user_input.startswith("!"):  # Shell command
            result = subprocess.getoutput(user_input[1:])
            speak(result)
        else:
            # Try OpenAI, fall back to local
            response = call_openai(user_input, config)
            if response.startswith("OpenAI error"):
                response = local_think(user_input)
            speak(response)

if __name__ == "__main__":
    main()
