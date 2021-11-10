mkdir -p temp
mkdir -p temp/grammar
mkdir -p temp/pronunciation

# Step 1
# $1 = sample
julia ./scripts/mkdfa.jl $1

# Step 2
# $2 = prompts.txt
julia ../bin/prompts2wlist.jl $2
HDMan -A -D -T 1 -m -w temp/pronunciation/wlist -n temp/pronunciation/monophones1 -i -l temp/pronunciation/dlog temp/pronunciation/dict model/VoxForgeDict.txt
sed '/sp/d' ./temp/pronunciation/monophones1 > ./temp/pronunciation/monophones0

# Step 4
julia ../bin/prompts2mlf.jl $2
HLEd -A -D -T 1 -l '*' -d temp/pronunciation/dict -i temp/transcription/phones0.mlf scripts/mkphones0.led temp/transcription/words.mlf
HLEd -A -D -T 1 -l '*' -d temp/pronunciation/dict -i temp/transcription/phones1.mlf scripts/mkphones1.led temp/transcription/words.mlf

# Step 5
## ----- GENERATE CODETRAIN.SCP -----
HCopy -A -D -T 1 -C config/wav_config -S temp/encoding/codetrain.scp
