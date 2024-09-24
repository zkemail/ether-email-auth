#!/bin/bash
set -e # Stop on error

mkdir -p build

npm install -g snarkjs@latest
pip install -r requirements.txt
mkdir build && cd build
gdown "https://drive.google.com/uc?id=1XDPFIL5YK8JzLGoTjmHLXO9zMDjSQcJH"
unzip params.zip
chmod +x circom_proofgen.sh
