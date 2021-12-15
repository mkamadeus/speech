New-Item -ItemType Directory -Force -Path "temp"
New-Item -ItemType Directory -Force -Path "temp/ngrams"
New-Item -ItemType Directory -Force -Path "temp/ngrams/db0"
New-Item -ItemType Directory -Force -Path "temp/ngrams/db1"
New-Item -ItemType Directory -Force -Path "temp/ngrams/lm"

# == Step 1 - Database Prep
# Create cum word map
LNewMap -f WFC Chess temp/ngrams/empty.wmap
# Populate word map and grammars
LGPrep -T 1 -b 200000 -d temp/ngrams/db0 -n 4 -s "7h3En1)!5(0m1N9" temp/ngrams/empty.wmap model/ngram-corpus.txt
# Sort entries
LGCopy -T 1 -b 200000 -d temp/ngrams/db1 temp/ngrams/db0/wmap $(gci temp/ngrams/db0/gram.*)

# == Step 2 - Generate LM
# Generate Unigrams
LBuild -T 1 -n 1 temp/ngrams/db0/wmap temp/ngrams/lm/ug $(gci temp/ngrams/db1/data.*)
# Generate Bigrams
LBuild -T 1 -c 2 1 -n 2 -f TEXT -l temp/ngrams/lm/ug temp/ngrams/db0/wmap temp/ngrams/lm/bg $(gci temp/ngrams/db1/data.*)
# Generate Trigrams
LBuild -T 1 -c 3 1 -n 3 -f TEXT -l temp/ngrams/lm/bg temp/ngrams/db0/wmap temp/ngrams/lm/tg $(gci temp/ngrams/db1/data.*)

# Copy out files
New-Item -ItemType Directory -Force -Path "out/"
cp temp/ngrams/lm/tg out/model.arpa