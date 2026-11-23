"""Download reference source only; never fetch ROM data or execute downloads."""
from pathlib import Path
from urllib.request import urlopen
import argparse
import re

parser = argparse.ArgumentParser()
parser.add_argument("files", nargs="+")
args = parser.parse_args()
root = Path(__file__).resolve().parent
for name in args.files:
    if not re.fullmatch(r"bank_[C-F][0-9A-F]\.asm|battle_work\.asm", name):
        parser.error("Only named assembly reference files are accepted")
    url = "https://raw.githubusercontent.com/dscotton/ct_disassembly/main/" + name
    with urlopen(url, timeout=25) as response:
        data = response.read(8 * 1024 * 1024 + 1)
    if len(data) > 8 * 1024 * 1024:
        raise ValueError("Reference exceeds expected size")
    (root / name).write_bytes(data)
    print(name, len(data))
