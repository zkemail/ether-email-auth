import modal

from core import (
    gen_email_auth_proof,
)


stub = modal.Stub("email-auth-prover-v1.0.1")

image = modal.Image.from_dockerfile("Dockerfile")


@stub.function(
    image=image,
    mounts=[
        modal.Mount.from_local_python_packages("core"),
    ],
    cpu=14,
)
@modal.wsgi_app()
def flask_app():
    from flask import Flask, request, jsonify
    import random
    import sys

    app = Flask(__name__)

    @app.post("/prove/email_auth")
    def prove_email_auth():
        req = request.get_json()
        input = req["input"]
        print(input)
        print(type(input))
        nonce = random.randint(
            0,
            sys.maxsize,
        )
        proof = gen_email_auth_proof(str(nonce), False, input)
        return jsonify(proof)
    return app
