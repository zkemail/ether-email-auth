#!/bin/sh

EMAIL_FILE_PATH=$1
ACCOUNT_CODE=$2

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKSPACE_DIR="${SCRIPT_DIR}/../../"
INPUT_FILE="${SCRIPT_DIR}/../build_integration/recovery_input.json"
yarn workspace @zk-email/email-tx-builder-circom gen-input \
    --email-file $EMAIL_FILE_PATH \
    --account-code $ACCOUNT_CODE \
    --input-file $INPUT_FILE \
    --prove
exit 0