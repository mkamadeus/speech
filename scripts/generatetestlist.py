import os
import sys

args = sys.argv[1:]
print(f"-----------------------------ARGS: {args}---------------------------------")

if len(args) > 0:
	PATH_TO_PROMPTS = f'model/{args[0]}'
else:
	PATH_TO_PROMPTS = 'model/prompts.txt'
PATH_TO_WAVLIST = 'temp/wavlist'

with open(PATH_TO_PROMPTS, 'r') as f:
    lines = list(map(lambda x: x.split(' ')[0], f.readlines()))
    lines = [l.replace('*', 'train') for l in lines]
    lines = [l.split(' ')[0] for l in lines]

with open(PATH_TO_WAVLIST, 'w') as f:
    f.write('\n'.join(lines))