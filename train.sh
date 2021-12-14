#!/bin/bash
set -e

function cleanup()
{
  echo "Training exited with status code $?"
}

trap cleanup EXIT

mkdir -p temp
mkdir -p temp/grammar
mkdir -p temp/pronunciation
mkdir -p temp/transcription
mkdir -p temp/encoding
mkdir -p temp/hmm/
mkdir -p temp/hmm/hmm0/
mkdir -p temp/hmm/hmm1/
mkdir -p temp/hmm/hmm2/
mkdir -p temp/hmm/hmm3/
mkdir -p temp/hmm/hmm4/
mkdir -p temp/hmm/hmm5/
mkdir -p temp/hmm/hmm6/
mkdir -p temp/hmm/hmm7/
mkdir -p temp/hmm/hmm8/
mkdir -p temp/hmm/hmm9/
mkdir -p temp/hmm/hmm10/
mkdir -p temp/hmm/hmm11/
mkdir -p temp/hmm/hmm12/
mkdir -p temp/hmm/hmm13/
mkdir -p temp/hmm/hmm14/
mkdir -p temp/hmm/hmm15/
mkdir -p temp/triphones/

# Step 1
# $1 = sample
julia scripts/mkdfa.jl $1

# Step 2
# $2 = prompts.txt
julia scripts/prompts2wlist.jl $2
HDMan -A -D -T 1 -m -w temp/pronunciation/wlist -n temp/pronunciation/monophones1 -i -l temp/pronunciation/dlog temp/pronunciation/dict $3
sed '/sp/d' ./temp/pronunciation/monophones1 > ./temp/pronunciation/monophones0

# Step 4
julia scripts/prompts2mlf.jl $2
HLEd -A -D -T 1 -l '*' -d temp/pronunciation/dict -i temp/transcription/phones0.mlf scripts/mkphones0.led temp/transcription/words.mlf
HLEd -A -D -T 1 -l '*' -d temp/pronunciation/dict -i temp/transcription/phones1.mlf scripts/mkphones1.led temp/transcription/words.mlf

# Step 5
python3 scripts/generatescp.py $2
HCopy -A -D -T 1 -C config/wav_config -S temp/encoding/codetrain.scp

# Step 6
HCompV -A -D -T 1 -C config/train_config -f 0.01 -m -S temp/hmm/train.scp -M temp/hmm/hmm0 config/proto
cp temp/pronunciation/monophones0 temp/hmm/hmm0/hmmdefs

# Do Flat Start Monophones http://voxforge.org/home/dev/acousticmodels/windows/create/htkjulius/tutorial/monophones/step-6
cp temp/hmm/hmm0/vFloors temp/hmm/hmm0/macros
python3 scripts/hmmprotogen.py

# Do Create macros file http://voxforge.org/home/dev/acousticmodels/windows/create/htkjulius/tutorial/monophones/step-6
for i in `seq 0 2`
do
  HERest -A -D -T 1 -C config/train_config -I temp/transcription/phones0.mlf -t 250.0 150.0 1000.0 -S temp/hmm/train.scp -H temp/hmm/hmm$i/macros -H temp/hmm/hmm$i/hmmdefs -M temp/hmm/hmm$(($i+1)) temp/pronunciation/monophones0
done

# Step 7
cp temp/hmm/hmm3/hmmdefs temp/hmm/hmm4/hmmdefs
python3 scripts/addsp.py
cp temp/hmm/hmm3/macros temp/hmm/hmm4/macros
HHEd -A -D -T 1 -H temp/hmm/hmm4/macros -H temp/hmm/hmm4/hmmdefs -M temp/hmm/hmm5 scripts/sil.hed temp/pronunciation/monophones1
HERest -A -D -T 1 -C config/train_config  -I temp/transcription/phones1.mlf -t 250.0 150.0 3000.0 -S temp/hmm/train.scp -H temp/hmm/hmm5/macros -H  temp/hmm/hmm5/hmmdefs -M temp/hmm/hmm6 temp/pronunciation/monophones1
HERest -A -D -T 1 -C config/train_config  -I temp/transcription/phones1.mlf -t 250.0 150.0 3000.0 -S temp/hmm/train.scp -H temp/hmm/hmm6/macros -H  temp/hmm/hmm6/hmmdefs -M temp/hmm/hmm7 temp/pronunciation/monophones1

# Step 8
HVite -A -D -T 1 -l '*' -o SWT -b SENT-END -C config/train_config -H temp/hmm/hmm7/macros -H temp/hmm/hmm7/hmmdefs -i temp/hmm/aligned.mlf -m -t 250.0 150.0 1000.0 -y lab -a -I temp/transcription/words.mlf -S temp/hmm/train.scp temp/pronunciation/dict temp/pronunciation/monophones1 > temp/HVite_log
HERest -A -D -T 1 -C config/train_config -I temp/hmm/aligned.mlf -t 250.0 150.0 3000.0 -S temp/hmm/train.scp -H temp/hmm/hmm7/macros -H temp/hmm/hmm7/hmmdefs -M temp/hmm/hmm8 temp/pronunciation/monophones1
HERest -A -D -T 1 -C config/train_config -I temp/hmm/aligned.mlf -t 250.0 150.0 3000.0 -S temp/hmm/train.scp -H temp/hmm/hmm8/macros -H temp/hmm/hmm8/hmmdefs -M temp/hmm/hmm9 temp/pronunciation/monophones1

# Step 9
HLEd -A -D -T 1 -n temp/triphones/triphones1 -l '*' -i temp/triphones/wintri.mlf scripts/mktri.led temp/hmm/aligned.mlf
julia scripts/mktrihed.jl temp/pronunciation/monophones1 temp/triphones/triphones1 temp/hmm/mktri.hed
HHEd -A -D -T 1 -H temp/hmm/hmm9/macros -H temp/hmm/hmm9/hmmdefs -M temp/hmm/hmm10 temp/hmm/mktri.hed temp/pronunciation/monophones1
HERest  -A -D -T 1 -C config/train_config -I temp/triphones/wintri.mlf -t 250.0 150.0 3000.0 -S temp/hmm/train.scp -H temp/hmm/hmm10/macros -H temp/hmm/hmm10/hmmdefs -M temp/hmm/hmm11 temp/triphones/triphones1
HERest  -A -D -T 1 -C config/train_config -I temp/triphones/wintri.mlf -t 250.0 150.0 3000.0 -s temp/stats -S temp/hmm/train.scp -H temp/hmm/hmm11/macros -H temp/hmm/hmm11/hmmdefs -M temp/hmm/hmm12 temp/triphones/triphones1

# Step 10
HDMan -A -D -T 1 -b sp -n temp/triphones/fulllist0 -g scripts/maketriphones.ded -l flog temp/triphones/dict-tri $3
julia scripts/fixfulllist.jl temp/triphones/fulllist0 temp/pronunciation/monophones0 temp/triphones/fulllist
cp scripts/tree.hed temp/tree.hed
julia scripts/mkclscript.jl temp/pronunciation/monophones0 temp/tree.hed temp/triphones
HHEd -A -D -T 1 -H temp/hmm/hmm12/macros -H temp/hmm/hmm12/hmmdefs -M temp/hmm/hmm13 temp/tree.hed temp/triphones/triphones1
HERest -A -D -T 1 -T 1 -C config/train_config -I temp/triphones/wintri.mlf  -t 250.0 150.0 3000.0 -S temp/hmm/train.scp -H temp/hmm/hmm13/macros -H temp/hmm/hmm13/hmmdefs -M temp/hmm/hmm14 temp/triphones/tiedlist
HERest -A -D -T 1 -T 1 -C config/train_config -I temp/triphones/wintri.mlf  -t 250.0 150.0 3000.0 -S temp/hmm/train.scp -H temp/hmm/hmm14/macros -H temp/hmm/hmm14/hmmdefs -M temp/hmm/hmm15 temp/triphones/tiedlist

# Copy out files
mkdir -p out/
cp temp/grammar/sample.dfa out/sample.dfa
cp temp/grammar/sample.dict out/sample.dict
cp temp/hmm/hmm15/hmmdefs out/hmmdefs
cp temp/triphones/tiedlist out/tiedlist
