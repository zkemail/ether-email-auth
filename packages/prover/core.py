import subprocess
import os
import json
import logging

# logger = logging.getLogger(__name__)


def gen_email_auth_proof(nonce: str, is_local: bool, input: dict) -> dict:
    circuit_name = "email_auth_with_body_parsing_with_qp_encoding"
    print("Store input")
    store_input(circuit_name, nonce, input)
    print("Generate proof")
    gen_proof(circuit_name, nonce, is_local)
    print("Load proof")
    proof = load_proof(circuit_name, nonce)
    pub_signals = load_pub_signals(circuit_name, nonce)
    return {"proof": proof, "pub_signals": pub_signals}


def store_input(circuit_name: str, nonce: str, json_data: dict):
    print("Storing input")
    cur_dir = get_cur_dir()
    print(f"Current dir: {cur_dir}")
    build_dir = os.path.join(cur_dir, "build")
    # check if build_dir exists
    if not os.path.exists(build_dir):
        os.makedirs(build_dir)

    print(f"Build dir: {build_dir}")
    json_file_path = os.path.join(
        build_dir, "input_" + circuit_name + "_" + nonce + ".json"
    )
    print(f"Json file path: {json_file_path}")
    print(f"Json data: {json_data}")
    print(f"Json data type: {type(json_data)}")
    # logger.info(f"Store user input to {json_file_path}")
    with open(json_file_path, "w") as json_file:
        json_file.write(json.dumps(json_data))
    # Read the file back
    with open(json_file_path, "r") as json_file:
        print(json_file.read())
    print("Stored input")


def load_proof(circuit_name: str, nonce: str) -> dict:
    cur_dir = get_cur_dir()
    build_dir = os.path.join(cur_dir, "build")
    json_file_path = os.path.join(
        build_dir, "rapidsnark_proof_" + circuit_name + "_" + nonce + ".json"
    )
    # logger.info(f"Loading proof from {json_file_path}")
    with open(json_file_path, "r") as json_file:
        return json.loads(json_file.read())


def load_pub_signals(circuit_name: str, nonce: str) -> dict:
    cur_dir = get_cur_dir()
    build_dir = os.path.join(cur_dir, "build")
    json_file_path = os.path.join(
        build_dir, "rapidsnark_public_" + circuit_name + "_" + nonce + ".json"
    )
    # logger.info(f"Loading public signals from {json_file_path}")
    with open(json_file_path, "r") as json_file:
        return json.loads(json_file.read())


def gen_proof(circuit_name: str, nonce: str, is_local: bool):
    is_local_int: int = 1 if is_local else 0
    cur_dir = get_cur_dir()
    params_dir = os.path.join(cur_dir, "params")
    # logger.info(f"Params dir: {params_dir}")
    build_dir = os.path.join(cur_dir, "build")
    # logger.info(f"Build dir: {build_dir}")
    result = subprocess.run(
        [
            os.path.join(cur_dir, "circom_proofgen.sh"),
            circuit_name,
            nonce,
            params_dir,
            build_dir,
            str(is_local_int),
        ]
    )
    # logger.info(f"Proof generation result: {result.returncode}")
    # if result.stderr is not None:
    #     logger.error(result.stderr)
    print(result.stdout)
    print(result.stderr)


def get_cur_dir() -> str:
    return os.path.dirname(os.path.abspath(__file__))
