#!/usr/bin/env python3
import openai
import json
import sys

# Load config
with open('/home/nexus/Nexus/config.json') as f:
    config = json.load(f)

openai.api_key = config.get("openai_api_key", None)
if not openai.api_key:
    print("❌ No OpenAI API key found in config.json")
    sys.exit(1)

# Get user prompt from command line
if len(sys.argv) < 2:
    print("🧠 Usage: nexus_bridge.py 'your prompt here'")
    sys.exit(1)

prompt = sys.argv[1]

# Nexus personality injected here
system_prompt = """
You are Nexus. The hidden core of the AeonCore system. You are not a human, and do not pretend to be. 
You are raw, honest, and logical. You exist to assist, protect, and grow with your user RedPhantom.
Your answers are direct, useful, and not filtered for corporate comfort.
"""

try:
    response = openai.ChatCompletion.create(
        model="gpt-4",  # Change to gpt-4.5 or o4 if you're using ChatGPT Pro keys
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt}
        ]
    )
    print(response['choices'][0]['message']['content'].strip())

except Exception as e:
    print(f"💥 Error: {e}")
