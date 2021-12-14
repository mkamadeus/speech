# speech

## Requirements

- HTK (http://voxforge.org/home/dev/acousticmodels/linux/create/htkjulius/tutorial/download)
- Julius
- Julia

Optional requirements for running in a container:

- Docker

## Running

### On Windows

```powershell
train.ps1 [grammar-prefix] [train-text] [train-lexicon]
train.ps1 chess train.txt dict.txt
```

### On \*nix

```bash
./train.sh chess train.txt dict.txt
```
