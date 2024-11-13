#!/bin/bash
set -e # Stop on error

mkdir -p build

npm install -g snarkjs@latest
pip install -r requirements.txt
mkdir build && cd build
# gdown "https://drive.google.com/uc?id=1XDPFIL5YK8JzLGoTjmHLXO9zMDjSQcJH"
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_prod1.zkey --output ./email_auth.zkey
mkdir ./email_auth_cpp
cd ./email_auth_cpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth --output ./email_auth
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/Makefile --output ./Makefile
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/calcwit.cpp --output ./calcwit.cpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/calcwit.hpp --output ./calcwit.hpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/calcwit.o --output ./calcwit.o
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/circom.hpp --output ./circom.hpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/email_auth.cpp --output ./email_auth.cpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/email_auth.dat --output ./email_auth.dat
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.asm --output ./fr.asm
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.cpp --output ./fr.cpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.hpp --output ./fr.hpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr.o --output ./fr.o
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/fr_asm.o --output ./fr_asm.o
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/main.cpp --output ./main.cpp
curl https://storage.googleapis.com/circom-ether-email-auth/v1.0.2/email_auth_cpp/main.o --output ./main.o
chmod +x ./email_auth
cd ../../
# unzip params.zip
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-account-creation/contributions/emailwallet-account-creation_00019.zkey --output /root/params/account_creation.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-account-init/contributions/emailwallet-account-init_00007.zkey --output /root/params/account_init.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-account-transport/contributions/emailwallet-account-transport_00005.zkey --output /root/params/account_transport.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-claim/contributions/emailwallet-claim_00006.zkey --output /root/params/claim.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-email-sender/contributions/emailwallet-email-sender_00006.zkey --output /root/params/email_sender.zkey
chmod +x circom_proofgen.sh