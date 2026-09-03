"""
Basic extraction of the hex byte array from the FalconFlank PoC.

python3 FalconFlank_hextract.py doc.h
[+] Extracted 93696 bytes
[+] Saved to payload.bin
SHA256 : d556a95fd234088ac0319d1e15674db729784c06980ca2e362e8ce08c2767ac7

https://github.com/MSNightmare/FalconFlank/blob/main/doc.h
"""
import re
import hashlib
from pathlib import Path

INPUT_FILE = "doc.h"
OUTPUT_FILE = "payload.bin"

with open(INPUT_FILE, "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

m = re.search(
    r'unsigned\s+char\s+rawData\s*\[\s*\d+\s*\]\s*=\s*\{(.*?)\};',
    content,
    re.DOTALL
)

if not m:
    raise ValueError("Could not locate rawData array")

array_text = m.group(1)
hex_bytes = re.findall(r'0x([0-9A-Fa-f]{2})', array_text)
data = bytes(int(x, 16) for x in hex_bytes)

with open(OUTPUT_FILE, "wb") as f:
    f.write(data)

print(f"[+] Extracted {len(data)} bytes")
print(f"[+] Saved to {OUTPUT_FILE}")
print(f"SHA256 : {hashlib.sha256(data).hexdigest()}")
