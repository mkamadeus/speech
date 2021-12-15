# speech

## Requirements

- HTK (http://voxforge.org/home/dev/acousticmodels/linux/create/htkjulius/tutorial/download)
- Julius
- Julia

Optional requirements for running in a container:

- Docker

## Populating Data

1. Record in 16kHz sample rate, 16 bitrate, and mono.
2. Add paths to your audio file in `train.txt`.

## Training the Model

### On Windows

```powershell
train.ps1 [grammar-prefix] [train-text] [train-lexicon]
train.ps1 chess train.txt dict.txt
```

### On \*nix

```bash
./train.sh chess train.txt dict.txt
```
