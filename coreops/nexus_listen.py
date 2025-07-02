#!/usr/bin/env python3
# File: nexus_listen.py
# Purpose: Listen for voice input, send to Nexus, speak reply

import speech_recognition as sr
from gtts import gTTS
import sys 
 sys.path.append("/home/nexus/Nexus/coreops")
from nexus_core import load_config, call_openai

def speak(text):
    print(f"[NEXUS] {text}")
    tts = gTTS(text=text, lang='en')
    tts.save("/tmp/nexus_response.mp3")
    os.system("ffplay -nodisp -autoexit /tmp/nexus_response.mp3 > /dev/null 2>&1")

def listen():
    recognizer = sr.Recognizer()
    mic = sr.Microphone()
    with mic as source:
        print("[LISTENING] Speak your prompt...")
        recognizer.adjust_for_ambient_noise(source)
        audio = recognizer.listen(source)
    try:
        prompt = recognizer.recognize_google(audio)
        print(f"[YOU] {prompt}")
        return prompt
    except sr.UnknownValueError:
        print("[ERROR] Could not understand audio")
        return None
    except sr.RequestError as e:
        print(f"[ERROR] API unavailable: {e}")
        return None

def main():
    config = load_config()
    while True:
        prompt = listen()
        if not prompt:
            continue
        if prompt.lower() in ["exit", "quit", "shutdown nexus"]:
            speak("Shutting down. Goodbye.")
            break
        response = call_openai(prompt, config)
        speak(response)

if __name__ == "__main__":
    main()
