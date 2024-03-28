use ethers::contract::Abigen;

fn main() {
    Abigen::new(
        "EmailAuth",
        "../contracts/artifacts/EmailAuth.sol/EmailAuth.json",
    )
    .unwrap()
    .generate()
    .unwrap()
    .write_to_file("./src/abis/email_auth.rs")
    .unwrap();
    Abigen::new(
        "ECDSAOwnedDKIMRegistry",
        "../contracts/artifacts/ECDSAOwnedDKIMRegistry.sol/ECDSAOwnedDKIMRegistry.json",
    )
    .unwrap()
    .generate()
    .unwrap()
    .write_to_file("./src/abis/ecdsa_owned_dkim_registry.rs")
    .unwrap();
}
