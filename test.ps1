New-Item -ItemType Directory -Force -Path "temp"
New-Item -ItemType Directory -Force -Path "temp/encoding"
New-Item -ItemType Directory -Force -Path "temp/transcriptions"

# Generate transcriptions
julia scripts/prompts2mlf.jl $ARGS[0]

# Generate list of files
python scripts/generatescp.py $ARGS[0]
python scripts/generatetestlist.py $ARGS[0]

# Recognize audio
julius-4.3.1.exe -input rawfile -filelist temp/wavlist -C config/sample.jconf | Set-Content temp/juliusOutput

python scripts/processjuliusoutput.py

# Evaluate
HResults -I temp/transcription/words.mlf temp/triphones/tiedlist temp/juliusoutput.mlf
