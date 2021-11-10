mkdir -p temp
mkdir -p temp/grammar
mkdir -p temp/pronunciation

# Step 1
julia ./scripts/mkdfa.jl $1

# Step 2
julia ../bin/prompts2wlist.jl $2
HDMan -A -D -T 1 -m -w temp/pronunciation/wlist -n temp/pronunciation/monophones1 -i -l temp/pronunciation/dlog temp/pronunciation/dict model/VoxForgeDict.txt
sed '/sp/d' ./temp/pronunciation/monophones1 > ./temp/pronunciation/monophones0
