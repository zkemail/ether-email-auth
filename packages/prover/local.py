#!/usr/bin/env python
# encoding: utf-8

from flask import Flask, request, jsonify
import random
import sys
from core import (
    gen_email_auth_proof,
)
import logging

app = Flask(__name__)


@app.route("/prove/email_auth", methods=["POST"])
def prove_email_auth():
    logger = logging.getLogger(__name__)
    req = request.get_json()
    logger.info(req)
    input = req["input"]
    # print(input)
    # print(type(input))
    nonce = random.randint(
        0,
        sys.maxsize,
    )
    logger.info(nonce)
    proof = gen_email_auth_proof(str(nonce), True, input, logger)
    logger.info(proof)
    return jsonify(proof)


if __name__ == "__main__":
    from waitress import serve

    serve(app, host="0.0.0.0", port=8080)
