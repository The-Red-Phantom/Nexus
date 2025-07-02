import json
import os
import sqlite3
import sys
from datetime import datetime

# Paths
BASE_DIR ="/home/nexus/Nexus"
SYM_PATH ="/home/nexus/Nexus/coreops/mcl/symbols.json"
DB_PATH ="/home/nexus/Nexus/coreops/mcl/mcl_memory.db"

# Load symbols
with open(SYM_PATH, "r") as f:
    SYMBOLS = json.load(f)

# DB Init
conn = sqlite3.connect(DB_PATH)
c = conn.cursor()
c.execute("""
    CREATE TABLE IF NOT EXISTS memory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol TEXT,
        value TEXT,
        timestamp TEXT
    )
""")
conn.commit()

# Compression: logs with timestamp
def compress(key: str, value: str):
    symbol = SYMBOLS.get(f"{key}:{value}", f"{key}:{value}")
    timestamp = datetime.utcnow().isoformat()
    c.execute("INSERT INTO memory (symbol, value, timestamp) VALUES (?, ?, ?)",
              (symbol, value, timestamp))
    conn.commit()
    return symbol

# Decompression: get most recent value for a symbol
def decompress(symbol: str):
    c.execute("SELECT value FROM memory WHERE symbol = ? ORDER BY id DESC LIMIT 1", (symbol,))
    result = c.fetchone()
    return result[0] if result else None

# Show full memory log
def show_memory():
    c.execute("SELECT symbol, value, timestamp FROM memory ORDER BY id DESC")
    return c.fetchall()

# Rehydrate: return most recent known state per symbol
def rehydrate_last_state():
    c.execute("""
        SELECT symbol, value FROM memory
        WHERE id IN (
            SELECT MAX(id) FROM memory GROUP BY symbol
        )
    """)
    return dict(c.fetchall())

# CLI interface
def main():
    if len(sys.argv) == 3:
        key, value = sys.argv[1], sys.argv[2]
        print(f"[MCL] Compressing {key}:{value}")
        print(compress(key, value))
    elif len(sys.argv) == 2 and sys.argv[1] == "show":
        print("[MCL] Current memory state:")
        for sym, val, time in show_memory():
            print(f"{sym} -> {val} @ {time}")
    elif len(sys.argv) == 2 and sys.argv[1] == "rehydrate":
        print("[MCL] Rehydrating last known state:")
        state = rehydrate_last_state()
        for sym, val in state.items():
            print(f"{sym} = {val}")
    else:
        print("[MCL] Usage:")
        print("  python3 mcl_engine.py <key> <value>    # Compress")
        print("  python3 mcl_engine.py show              # Show log")
        print("  python3 mcl_engine.py rehydrate         # Rehydrate last state")

if __name__ == "__main__":
    main()

