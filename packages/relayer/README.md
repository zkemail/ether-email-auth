This is a Relayer server implementation in Rust for email-based account recovery.

## How to Run the Relayer
You can run the relayer either on your local environments or cloud instances (we are using GCP).
### Local
1. Clone the repo, https://github.com/zkemail/ether-email-auth.
2. Install dependencies.
    1. `cd ether-email-auth` and run `yarn`.
3. If you have not deployed common contracts, build contract artifacts and deploy required contracts.
    1. `cd packages/contracts` and run `forge build`.
    2. Set the env file in `packages/contracts/.env`, an example env file is as follows,

    ```jsx
    LOCALHOST_RPC_URL=http://127.0.0.1:8545
    SEPOLIA_RPC_URL=https://sepolia.base.org
    MAINNET_RPC_URL=https://mainnet.base.org

    PRIVATE_KEY=""
    CHAIN_ID=84532
    RPC_URL="https://sepolia.base.org"
    SIGNER=0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0 # Signer for the dkim oracle on IC
    ETHERSCAN_API_KEY=
    # CHAIN_NAME="base_sepolia"
    ```
    3. Run `forge script script/DeployCommons.s.sol:Deploy -vvvv --rpc-url $RPC_URL --broadcast` to get `ECDSAOwnedDKIMRegistry`, `Verifier`, `EmailAuth implementation` and `SimpleWallet implementation`.
4. Install PostgreSQL and create a database.
    1. `psql -U <admin_user> -d postgres` to login to administrative PostgreSQL user. Replace **`<admin_user>`** with the administrative PostgreSQL user (commonly **`postgres`**).
    2. Create a new user, `CREATE USER my_new_user WITH PASSWORD 'my_secure_password';`, `ALTER USER my_new_user CREATEDB;`.
    3. Exit `psql` and now create a new database, `psql -U new_user -d postgres` followed by `CREATE DATABASE my_new_database;`.
5. Run the prover.
    1. `cd packages/prover` and `python local.py`, let this run async.
6. Run the relayer.
    1. `cd packages/relayer`.
    2. Set the env file, an example env file is as follows,
        ```jsx
        EMAIL_ACCOUNT_RECOVERY_VERSION_ID=1           # Address of the deployed wallet contract.
        PRIVATE_KEY=                      # Private key for Relayer's account.
        CHAIN_RPC_PROVIDER=https://sepolia.base.org
        CHAIN_RPC_EXPLORER=https://sepolia.basescan.org
        CHAIN_ID=84532                    # Chain ID of the testnet.

        # IMAP + SMTP (Settings will be provided by your email provider)
        IMAP_DOMAIN_NAME=imap.gmail.com
        IMAP_PORT=993
        AUTH_TYPE=password
        SMTP_DOMAIN_NAME=smtp.gmail.com
        LOGIN_ID=                    # IMAP login id - usually your email address.
        LOGIN_PASSWORD=""         # IMAP password - usually your email password.

        PROVER_ADDRESS="http://localhost:8080"  # Address of the prover.

        DATABASE_URL= "postgres://new_user:my_secure_password@localhost/my_new_database"
        WEB_SERVER_ADDRESS="127.0.0.1:4500"
        EMAIL_TEMPLATES_PATH=  # Absolute path to packages/relayer/eml_templates

        CANISTER_ID="q7eci-dyaaa-aaaak-qdbia-cai"
        PEM_PATH="./.ic.pem"
        IC_REPLICA_URL="https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=q7eci-dyaaa-aaaak-qdbia-cai"
        ERROR_EMAIL_ADDR="" # System user email address receiving error notification for user
        JSON_LOGGER=false
        ```
    3. Generate the `.ic.pem` file and password.
        - Create the `.ic.pem` file using OpenSSL:
        ```sh
        openssl genpkey -algorithm RSA -out .ic.pem -aes-256-cbc -pass pass:your_password
        ```
        - If you need a password, you can generate a random password using:
        ```sh
        openssl rand -base64 32
        ```
7. You should have your entire setup up and running!

NOTE: You need to turn on IMAP on the email id you’d be using for the relayer.

#### Appendix: If you use your own gmail for the relayer

If you intend to use a Gmail address, you need to configure your Google account and Gmail as follows:

##### Enable IMAP:

Gmail -> See all settings -> Forwarding and POP/IMAP -> IMAP access -> Enable IMAP.

Note that from June 2024, IMAP will be enabled by default.

##### Enable two-factor authentication for your Google account:

Refer to the following help link.

[Google 2FA Setup](https://support.google.com/accounts/answer/185839?hl=en&co=GENIE.Platform%3DDesktop)

##### Create an app password:

Refer to the following help link. If you do not see the 'App passwords' option, try searching for 'app pass' in the search box to select it.

[Google App Passwords](https://support.google.com/accounts/answer/185833?hl=en)

### Production on GCP
1. Install `kubectl` on your system (https://kubernetes.io/docs/tasks/tools/)
2. Setup k8s config of `zkemail` cluster on GKE,
`gcloud container clusters get-credentials zkemail --region us-central1 --project (your_project_name)`
3. One time steps (already done)
    1. Create a static IP (https://cloud.google.com/vpc/docs/reserve-static-external-ip-address#gcloud)
    2. Map the static IP with a domain from Google Domain
    3. Create a `Managed Certificate` by applying `kubernetes/managed-cert.yml` (update the domain accordingly)
4. (Optional) Delete `db.yml` , `ingress.yml`  and `relayer.yml` if applied already
5. (Optional) Build the Relayer’s Docker image and publish it.
6. Set the config in the respective manifests (Here, you can set the image of the relayer in `relayer.yml` , latest image already present in the config.)
7. Apply `db.yml`
8. Apply `relayer.yml` , ssh into the pod and run `nohup cargo run &` , this step should be done under a min to pass the liveness check.
9. Apply `ingress.yml`

## Specification
### Database
It has the following tables in the DB.
- `credentials`: a table to store an account code for each pair of the wallet address and the guardian's email address.
    - `account_code TEXT PRIMARY KEY`
    - `account_eth_addr TEXT NOT NULL`
    - `guardian_email_addr TEXT NOT NULL`
    - `is_set BOOLEAN NOT NULL DEFAULT FALSE`

- `requests`: a table to store requests from the caller of REST APIs.
    - `request_id BIGINT PRIMARY KEY`
    - `account_eth_addr TEXT, NOT NULL`
    - `controller_eth_addr TEXT NOT NULL`
    - `guardian_email_addr TEXT NOT NULL`
    - `is_for_recovery  BOOLEAN NOT NULL DEFAULT FALSE`
    - `template_idx INT NOT NULL`
    - `is_processed BOOLEAN NOT NULL DEFAULT FALSE`
    - `is_success BOOLEAN`
    - `email_nullifier TEXT`
    - `account_salt TEXT`

### REST APIs
It exposes the following REST APIs.

- `GET requestStatus`
    1. Receive  `request_id`.
    2. Retrieve a record with `request_id` from the `requests` table. If such a record does not exist, return 0.
    3. If `is_processed` is false, return 1. Otherwise, return 2, `is_success`, `email_nullifier`, `account_salt`.

- `POST getAccountSalt`
    1. Receive `account_code` and `email_addr`.
    2. Compute `account_salt` from the given `account_code` and `email_addr`.
    3. Return `account_salt`.

- `POST acceptanceRequest`
    1. Receive  `controller_eth_addr`, `guardian_email_addr`, `account_code`, `template_idx`, and `subject`.
    2. Let `subject_template` be the `template_idx`-th template in `acceptanceSubjectTemplates()` of `controller_eth_addr`.
    3. If `subject` does not match with `subject_template` return a 400 response. Let `subject_params` be the parsed values.
    4. Extract `account_eth_addr` from the given `subject` by following `subject_template`.
    5. If the contract of `account_eth_addr` is not deployed, return a 400 response.
    4. If a record with `account_code` exists in the `credentials` table, return a 400 response.
    6. Randomly generate a `request_id`. If a record with `request_id` exists in the `requests` table, regenerate a new `request_id`.
    7. If a record with `account_eth_addr`, `guardian_email_addr` and `is_set=true` exists in the `credentials`  table,
        1. Insert `(request_id, account_eth_addr, controller_eth_addr, guardian_email_addr, false, template_idx, false)` into the `requests` table.
        2. Send `guardian_email_addr` an error email to say that `account_eth_addr` tries to set you to a guardian, which is rejected since you are already its guardian.
        3. Return a 200 response along with `request_id` and `subject_params` **to prevent a malicious client user from learning if the pair of the `account_eth_addr` and the `guardian_email_addr` is already set or not.**
    8. Insert `(account_code, account_eth_addr, controller_eth_addr, guardian_email_addr, false)` into the `credentials` table.
    9. Insert `(request_id, account_eth_addr, controller_eth_addr, guardian_email_addr, false, template_idx)` into the `requests` table.
    10. Send an email as follows.
        - To: `guardian_email_addr`
        - Subject: if the domain of `guardian_email_addr` signs the To field, `subject`. Otherwise, `subject + " Code " + hex(account_code)"`.
        - Reply-to: `relayer_email_addr_before_domain + "+code" + hex(account_code) + "@" + relayer_email_addr_domain`.
        - Body: Any message, but it MUST contain `"#" + digit(request_id)`.
    11. Return a 200 response along with `request_id` and `subject_params`.

- `POST recoveryRequest`
    1. Receive  `controller_eth_addr`, `guardian_email_addr`, `template_idx`, and `subject`.
    2. Let `subject_template` be the `template_idx`-th template in `recoverySubjectTemplates()` of `account_eth_addr`.
    3. If the `subject` does not match with `subject_template` return a 400 response. Let `subject_params` be the parsed values.
    4. Extract `account_eth_addr` from the given `subject` by following `subject_template`.
    5. If the contract of `account_eth_addr` is not deployed, return a 400 response.
    6. Randomly generate a `request_id`. If a record with `request_id` exists in the `requests` table, regenerate a new `request_id`.
    7. If a record with `account_eth_addr`, `guardian_email_addr`, and `is_set=true` exists in the `credentials`  table,
        1. Insert `(request_id, account_eth_addr, controller_eth_addr, guardian_email_addr, true, template_idx, false)` into the `requests` table.
        2. Send an email as follows.
            - To: `guardian_email_addr`
            - Subject: if the domain of `guardian_email_addr` signs the To field, `subject`. Otherwise, `subject + " Code " + hex(account_code)"`.
            - Reply-to: `relayer_email_addr_before_domain ~~+ "+code" + hex(account_code)~~ + "@" + relayer_email_addr_domain`.
            - Body: Any message, but it MUST contain `"#" + digit(request_id)`.
        3. Return a 200 response along with `request_id` and `subject_params`.
    7. If a record with `account_eth_addr`, `guardian_email_addr`, and `is_set=false` exists in the `credentials`  table,
        1. Insert `(request_id, account_eth_addr, guardian_email_addr, true, template_idx, false)` into the `requests` table.
        2. Send an email as follows.
            - To: `guardian_email_addr`
            - Subject: A message to say that `account_eth_addr` requests your account recovery, but you have not approved being its guardian.
        3. Return a 200 response along with `request_id` and `subject_params`.
    8. If a record with `account_eth_addr`, `guardian_email_addr` does not exist in the `credentials`  table,
        1. Insert `(request_id, account_eth_addr, guardian_email_addr, true, template_idx, false)` into the `requests` table.
        2. Send an email as follows.
            - To: `guardian_email_addr`
            - Subject: if the domain of `guardian_email_addr` signs the To field, `subject`. Otherwise, `subject + " Code "`.
            - Reply-to: `relayer_email_addr_before_domain +  "@" + relayer_email_addr_domain`.
            - Body: Any message, but it MUST contain `"#" + digit(request_id)`. Also, the message asks the guardian to reply to this email **with the guardian’s account code after  `" Code "` in the subject.**
        3. Return a 200 response along with `request_id` and `subject_params`.

- `POST completeRequest`
    1. Receive  `account_eth_addr`, `controller_eth_addr`, and `complete_calldata`.
    2. If the contract of `acciybt_eth_addr` is not deployed, return a 400 response.
    3. Call the `completeRecovery` function in the contract of `controller_eth_addr` with passing `account_eth_addr` and `complete_calldata`.
    4. If the transaction fails, return a 400 response. Otherwise, return a 200 response.

### Handling Email
When receiving a new email, the relayer handles it as follows.
1. Extract `guardian_email_addr` from the From field, `raw_subject` from the Subject field, and `"#" + digit(request_id)` from the email body.
2. If no record with `request_id` exists in the `requests` table, send `guardian_email_addr` an email to tell that the given `request_id` does not exist.
3. If the invitation code for `account_code` exists in the email header,
    1. If a record with `account_code` exists in the `credentials` table, assert that `guardian_email_addr` is the same as the extracted one.
    2. If no record with `account_code` exists in the `credentials` table, assert that the `EmailAuth` contract whose address corresponds to `account_code` and `guardian_email_addr` is already deployed. Also, insert `(account_code, account_eth_addr, guardian_email_addr, true)` into the `credentials` table, where `account_eth_addr` is the owner of that deployed `EmailAuth` contract. Note that this step is for a guardian who sends an email to a new relayer due to the old relayer’s censorship.
4. Let `email_domain` be a domain of `guardian_email_addr`.
5. Fetch a public key of `email_domain` from DNS and compute its `public_key_hash`.
6. Let `dkim` be the output of `dkim()` of `account_eth_addr`.
7. If `DKIM(dkim).isDKIMPublicKeyHashValid(email_domain, public_key_hash)` is false, call the DKIM oracle and update the `dkim` contract.
8. If `is_for_recovery` is false,
    1. Let `subject_template` be the `template_idx`-th template in `acceptanceSubjectTemplates()` of `controller_eth_addr`.
    2. If `subject` does not match with `subject_template`, send `guardian_email_addr` an error email.
    3. Parse `subject` to get `subject_params` and `skiped_subject_prefix`.
    4. Let `templateId` be `keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "ACCEPTANCE", templateIdx)`.
    5. Generate a proof for the circuit and construct `email_proof`.
    6. Construct `email_auth_msg` and call `EmailAccountRecovery(controller_eth_addr).handleAcceptance(email_auth_msg, template_idx)`.
    7. If the transaction fails, send `guardian_email_addr` an error email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=false, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.email_nullifier, is_code_exist=email_proof.is_code_exist)`.
    8. Update a record with `account_code` in the `credentials` table to `is_set=true`.
    9. Send `guardian_email_addr` a success email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=true, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.email_nullifier, is_code_exist=email_proof.is_code_exist)`.
9. If `is_for_recovery` is true,
    1. Let `subject_template` be the `template_idx`-th template in `recoverySubjectTemplates()` of `controller_eth_addr`.
    2. If `subject` does not match with `subject_template`, send `guardian_email_addr` an error email.
    3. Parse `subject` to get `subject_params` and `skiped_subject_prefix`.
    4. Let `templateId` be `keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "RECOVERY", templateIdx)`.
    5. Generate a proof for the circuit and construct `email_proof`.
    6. Construct `email_auth_msg` and call `EmailAccountRecovery(controller_eth_addr).handleRecovery(email_auth_msg, template_idx)`.
    7. If the transaction fails, send `guardian_email_addr` an error email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=false, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.account_salt, is_code_exist=email_proof.is_code_exist)`.
    8. Send `guardian_email_addr` a success email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=true, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.email_nullifier, is_code_exist=email_proof.is_code_exist)`.
