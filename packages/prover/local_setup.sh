#!/bin/bash
set -e # Stop on error

mkdir -p build

npm install -g snarkjs@latest
pip install -r requirements.txt
mkdir build && cd build
gdown "https://drive.google.com/uc?id=1l3mNqFYv-YZc2efFlphFUkoaCnGCxFtE"
unzip params.zip
chmod +x circom_proofgen.sh
