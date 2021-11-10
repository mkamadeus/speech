setup:
	mkdir -p temp
	mkdir -p temp/grammar
	mkdir -p temp/pronunciation
.PHONY: setup

train: setup step1 step2 step4
.PHONY: train

step1:
	julia ./scripts/mkdfa.jl sample

step2:
	julia ../bin/prompts2wlist.jl prompts.txt
	HDMan -A -D -T 1 -m -w temp/pronunciation/wlist -n temp/pronunciation/monophones1 -i -l temp/pronunciation/dlog temp/pronunciation/dict model/VoxForgeDict.txt
	sed '/sp/d' ./temp/pronunciation/monophones1 > ./temp/pronunciation/monophones0

step4:
	julia ../bin/prompts2mlf.jl prompts.txt
	HLEd -A -D -T 1 -l '*' -d temp/pronunciation/dict -i temp/transcription/phones0.mlf scripts/mkphones0.led temp/transcription/words.mlf
	HLEd -A -D -T 1 -l '*' -d temp/pronunciation/dict -i temp/transcription/phones1.mlf scripts/mkphones1.led temp/transcription/words.mlf