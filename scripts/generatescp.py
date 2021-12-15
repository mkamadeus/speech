import os
import sys

args = sys.argv[1:]
print(f"-----------------------------ARGS: {args}---------------------------------")

if len(args) > 0:
	PATH_TO_PROMPTS = f'model/{args[0]}'
else:
	PATH_TO_PROMPTS = 'model/prompts.txt'
PATH_TO_CODETRAIN = 'temp/encoding/codetrain.scp'
PATH_TO_TRAIN = 'temp/hmm/train.scp'

with open(PATH_TO_PROMPTS, 'r') as f:
	lines = list(map(lambda x: x.split(' ')[0], f.readlines()))
	lines = [l.replace('*', 'train') for l in lines]
	codetrain_lines = [f"{l}.wav temp/encoding/{'-'.join(l.lower().split('/')[1:])}.mfc" for l in lines]
	train_lines = [f"temp/encoding/{'-'.join(l.lower().split('/')[1:])}.mfc" for l in lines]

with open(PATH_TO_CODETRAIN, 'w') as f:
	f.write('\n'.join(codetrain_lines))

with open(PATH_TO_TRAIN, 'w') as f:
	f.write('\n'.join(train_lines))
