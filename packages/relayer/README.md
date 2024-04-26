This is a Relayer server implementation in Rust for email-based account recovery.

## Specification
### Database
It has the following tables in the DB.
- `credentials`: a table to store an account code for each pair of the wallet address and the guardian's email address.
    - `account_code TEXT PRIMARY KEY`
    - `wallet_eth_addr TEXT NOT NULL`
    - `guardian_email_addr TEXT NOT NULL`
    - `is_set BOOLEAN NOT NULL DEFAULT FALSE`

- `requests`: a table to store requests from the caller of REST APIs.
    - `request_id BIGINT PRIMARY KEY`
    - `wallet_eth_addr TEXT, NOT NULL`
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
    1. Receive  `wallet_eth_addr`, `guardian_email_addr`, `account_code`, `template_idx`, and `subject`.
    2. If the contract of `wallet_eth_addr` is not deployed, return a 400 response.
    3. Let `subject_template` be the `template_idx`-th template in `acceptanceSubjectTemplates()` of `wallet_eth_addr`.
    4. If `subject` does not match with `subject_template` return a 400 response. Let `subject_params` be the parsed values.
    5. If a record with `account_code` exists in the `credentials` table, return a 400 response.
    6. Randomly generate a `request_id`. If a record with `request_id` exists in the `requests` table, regenerate a new `request_id`.
    7. If a record with `wallet_eth_addr`, `guardian_email_addr` and `is_set=true` exists in the `credentials`  table, 
        1. Insert `(request_id, wallet_eth_addr, guardian_email_addr, false, template_idx, false)` into the `requests` table.
        2. Send `guardian_email_addr` an error email to say that `wallet_eth_addr` tries to set you to a guardian, which is rejected since you are already its guardian. 
        3. Return a 200 response along with `request_id` and `subject_params` **to prevent a malicious client user from learning if the pair of the `wallet_eth_addr` and the `guardian_email_addr` is already set or not.**
    8. Insert `(account_code, wallet_eth_addr, guardian_email_addr, false)` into the `credentials` table.
    9. Insert `(request_id, wallet_eth_addr, guardian_email_addr, false, template_idx)` into the `requests` table.
    10. Send an email as follows.
        - To: `guardian_email_addr`
        - Subject: if the domain of `guardian_email_addr` signs the To field, `subject`. Otherwise, `subject + " Code " + hex(account_code)"`.
        - Reply-to: `relayer_email_addr_before_domain + "+code" + hex(account_code) + "@" + relayer_email_addr_domain`.
        - Body: Any message, but it MUST contain `"#" + digit(request_id)`.
    11. Return a 200 response along with `request_id` and `subject_params`.

- `POST recoveryRequest`
    1. Receive  `wallet_eth_addr`, `guardian_email_addr`, `template_idx`, and `subject`.
    2. If the contract of `wallet_eth_addr` is not deployed, return a 400 response.
    3. Let `subject_template` be the `template_idx`-th template in `recoverySubjectTemplates()` of `wallet_eth_addr`.
    4. If the `subject` does not match with `subject_template` return a 400 response. Let `subject_params` be the parsed values.
    5. Randomly generate a `request_id`. If a record with `request_id` exists in the `requests` table, regenerate a new `request_id`.
    6. If a record with `wallet_eth_addr`, `guardian_email_addr`, and `is_set=true` exists in the `credentials`  table, 
        1. Insert `(request_id, wallet_eth_addr, guardian_email_addr, true, template_idx)` into the `requests` table.
        2. Send an email as follows.
            - To: `guardian_email_addr`
            - Subject: if the domain of `guardian_email_addr` signs the To field, `subject`. Otherwise, `subject + " Code " + hex(account_code)"`.
            - Reply-to: `relayer_email_addr_before_domain ~~+ "+code" + hex(account_code)~~ + "@" + relayer_email_addr_domain`.
            - Body: Any message, but it MUST contain `"#" + digit(request_id)`.
        3. Return a 200 response along with `request_id` and `subject_params`.
    7. If a record with `wallet_eth_addr`, `guardian_email_addr`, and `is_set=false` exists in the `credentials`  table, 
        1. Insert `(request_id, wallet_eth_addr, guardian_email_addr, true, template_idx, ~~false~~)` into the `requests` table.
        2. Send an email as follows.
            - To: `guardian_email_addr`
            - Subject: A message to say that `wallet_eth_addr` requests your account recovery, but you have not approved being its guardian.
        3. Return a 200 response along with `request_id` and `subject_params`.
    8. If a record with `wallet_eth_addr`, `guardian_email_addr` does not exist in the `credentials`  table, 
        1. Insert `(request_id, wallet_eth_addr, guardian_email_addr, true, template_idx, false)` into the `requests` table.
        2. Send an email as follows.
            - To: `guardian_email_addr`
            - Subject: if the domain of `guardian_email_addr` signs the To field, `subject`. Otherwise, `subject + " Code "`.
            - Reply-to: `relayer_email_addr_before_domain +  "@" + relayer_email_addr_domain`.
            - Body: Any message, but it MUST contain `"#" + digit(request_id)`. Also, the message asks the guardian to reply to this email **with the guardian’s account code after  `" Code "` in the subject.**
        3. Return a 200 response along with `request_id` and `subject_params`.

- `POST complete~~Request~~Recovery`
    1. Receive  `wallet_eth_addr`.
    2. If the contract of `wallet_eth_addr` is not deployed, return a 400 response.
    3. Call the `completeRecovery` function in the contract of `wallet_eth_addr`.
    4. If the transaction fails, return a 400 response. Otherwise, return a 200 response.

### Handling Email
When receiving a new email, the relayer handles it as follows.
1. Extract `guardian_email_addr` from the From field, `raw_subject` from the Subject field, and `"#" + digit(request_id)` from the email body.
2. If no record with `request_id` exists in the `requests` table, send `guardian_email_addr` an email to tell that the given `request_id` does not exist.
3. If the invitation code for `account_code` exists in the email header,
    1. If a record with `account_code` exists in the `credentials` table, assert that `guardian_email_addr` is the same as the extracted one.
    2. If no record with `account_code` exists in the `credentials` table, assert that the `EmailAuth` contract whose address corresponds to `account_code` and `guardian_email_addr` is already deployed. Also, insert `(account_code, wallet_eth_addr, guardian_email_addr, true)` into the `credentials` table, where `wallet_eth_addr` is the owner of that deployed `EmailAuth` contract. Note that this step is for a guardian who sends an email to a new relayer due to the old relayer’s censorship.
4. Let `email_domain` be a domain of `guardian_email_addr`.
5. Fetch a public key of `email_domain` from DNS and compute its `public_key_hash`.
6. Let `dkim` be the output of `dkim()` of `wallet_eth_addr`.
7. If `DKIM(dkim).isDKIMPublicKeyHashValid(email_domain, public_key_hash)` is false, call the DKIM oracle and update the `dkim` contract.
8. If `is_for_recovery` is false,
    1. Let `subject_template` be the `template_idx`-th template in `acceptanceSubjectTemplates()` of `wallet_eth_addr`.
    2. If `subject` does not match with `subject_template`, send `guardian_email_addr` an error email.
    3. Parse `subject` to get `subject_params` and `skiped_subject_prefix`.
    4. Let `templateId` be `keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "ACCEPTANCE", templateIdx)`.
    5. Generate a proof for the circuit and construct `email_proof`.
    6. Construct `email_auth_msg` and call `EmailAccountRecovery(wallet_eth_addr).handleAcceptance(email_auth_msg, template_idx)`.
    7. If the transaction fails, send `guardian_email_addr` an error email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=false, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.email_nullifier, is_code_exist=email_proof.is_code_exist)`.
    8. Update a record with `account_code` in the `credentials` table to `is_set=true`.
    9. Send `guardian_email_addr` a success email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=true, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.email_nullifier, is_code_exist=email_proof.is_code_exist)`.
9. If `is_for_recovery` is true,
    1. Let `subject_template` be the `template_idx`-th template in `recoverySubjectTemplates()` of `wallet_eth_addr`.
    2. If `subject` does not match with `subject_template`, send `guardian_email_addr` an error email.
    3. Parse `subject` to get `subject_params` and `skiped_subject_prefix`.
    4. Let `templateId` be `keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "RECOVERY", templateIdx)`.
    5. Generate a proof for the circuit and construct `email_proof`.
    6. Construct `email_auth_msg` and call `EmailAccountRecovery(wallet_eth_addr).handleRecovery(email_auth_msg, template_idx)`.
    7. If the transaction fails, send `guardian_email_addr` an error email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=false, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.account_salt, is_code_exist=email_proof.is_code_exist)`.
    8. Send `guardian_email_addr` a success email and update a record with `request_id` in the `requests` table to `(is_processed=true, is_success=true, email_nullifier=email_proof.email_nullifier, account_salt=email_proof.email_nullifier, is_code_exist=email_proof.is_code_exist)`.
