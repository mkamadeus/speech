import os
import sys

args = sys.argv[1:]
print(f"-----------------------------ARGS: {args}---------------------------------")

JULIUS_OUTPUT_PATH = 'temp/juliusOutput'
WAVLIST_PATH = 'temp/wavlist'
MLF_PATH = 'temp/juliusoutput.mlf'

with open(JULIUS_OUTPUT_PATH, 'r') as f:
    julius_output = f.readlines()

with open(WAVLIST_PATH, 'r') as f:
    lines = ["#!MLF!#"]
    for jul in julius_output:
        if jul.startswith('sentence1'):
            words = jul.strip().split(' ')[2:-2]
            lines.append(f"\"{f.readline().strip()}.lab\"")
            lines.extend(words)
            lines.append(".")

with open(MLF_PATH, "w") as f:
    f.write('\n'.join(lines))