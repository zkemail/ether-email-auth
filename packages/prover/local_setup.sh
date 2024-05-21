#!/bin/bash
set -e # Stop on error

mkdir -p build

npm install -g snarkjs@latest
pip3 install -r requirements.txt
mkdir build && cd build
gdown "https://drive.google.com/uc?id=13_RItK372JdfQFM3TmQFU_svN7q0k5iF"
unzip params.zip
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-account-creation/contributions/emailwallet-account-creation_00019.zkey --output /root/params/account_creation.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-account-init/contributions/emailwallet-account-init_00007.zkey --output /root/params/account_init.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-account-transport/contributions/emailwallet-account-transport_00005.zkey --output /root/params/account_transport.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-claim/contributions/emailwallet-claim_00006.zkey --output /root/params/claim.zkey
# curl https://email-wallet-trusted-setup-ceremony-pse-p0tion-production.s3.eu-central-1.amazonaws.com/circuits/emailwallet-email-sender/contributions/emailwallet-email-sender_00006.zkey --output /root/params/email_sender.zkey
chmod +x circom_proofgen.sh
