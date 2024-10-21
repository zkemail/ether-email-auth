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
    // Abigen::new(
    //     "ECDSAOwnedDKIMRegistry",
    //     "../contracts/artifacts/ECDSAOwnedDKIMRegistry.sol/ECDSAOwnedDKIMRegistry.json",
    // )
    // .unwrap()
    // .generate()
    // .unwrap()
    // .write_to_file("./src/abis/ecdsa_owned_dkim_registry.rs")
    // .unwrap();
    Abigen::new(
        "UserOverridableDKIMRegistry",
        "../contracts/artifacts/UserOverrideableDKIMRegistry.sol/UserOverrideableDKIMRegistry.json",
    )
    .unwrap()
    .generate()
    .unwrap()
    .write_to_file("./src/abis/user_overridable_dkim_registry.rs")
    .unwrap();
    Abigen::new(
        "ForwardDKIMRegistry",
        "../contracts/artifacts/ForwardDKIMRegistry.sol/ForwardDKIMRegistry.json",
    )
    .unwrap()
    .generate()
    .unwrap()
    .write_to_file("./src/abis/forward_dkim_registry.rs")
    .unwrap();
    Abigen::new(
        "EmailAccountRecovery",
        "../contracts/artifacts/EmailAccountRecovery.sol/EmailAccountRecovery.json",
    )
    .unwrap()
    .generate()
    .unwrap()
    .write_to_file("./src/abis/email_account_recovery.rs")
    .unwrap();
}
