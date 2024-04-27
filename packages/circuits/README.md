# Circuit Architecture
## Circom Circuits
### Main Circuits

We provide one main circuit as follows.

#### `email_auth.circom`
A circuit to verify that a message in the subject is authorized by a user of an account salt, derived from an email address in the From field and a random field value called account code.

It takes as input the following data:
1. a padded email header `padded_header`.
2. the bytes of the padded email header `padded_header_len`.
3. an RSA public key `public_key`.
4. an RSA signature `signature`.
5. the sender's account code `account_code`.
6. a starting position of the From field in the email header `from_addr_idx`.
7. a starting position of the Subject field in the email header `subject_idx`.
8. a starting position of the email domain in the email address of the From field `domain_idx`.
10. a starting position of the timestamp in the email header `timestamp_idx`.
11. a starting position of the invitation code in the email header `code_idx`.

Its instances are as follows:
1. an email domain `domain_name`.
2. a Poseidon hash of the RSA public key `public_key_hash`.
3. a nullifier of the email `email_nullifier`.
4. a timestamp in the email header `timestamp`.
5. a masked subject where characters either in the email address or in the invitation code are replaced with zero  `masked_subject_str`.
6. an account salt `account_salt`.
7. a flag whether the email header contains the invitation code `is_code_exist`.

## How to Use
### Build circuits
`yarn && yarn build`

### Run tests
At `packages/circuits`, make a `build` directory, download the zip file from the following link, and place its unzipped directory under `build`.
https://drive.google.com/file/d/13_RItK372JdfQFM3TmQFU_svN7q0k5iF/view?usp=drive_link

Then, move `email_auth.zkey` in the unzipped directory `params` to `build`. 

Then run the following command.
`yarn test`

### Generate proving keys and verifier contracts for main circuits
`yarn dev-setup`

## Specification
The `email_auth.circom` makes constraints and computes the public output as follows.
1. Assert that `signature` is valid for `padded_header` and `public_key`.
2. Let `public_key_hash` be `PoseidonHash(public_key)`.
3. Let `email_nullifier` be `PoseidonHash(PoseidonHash(signature))`.
4. Let `from_addr` be `padded_header[from_addr_idx:from_addr_idx+256]` .
5. Let `subject` be `padded_header[subject_idx:subject_idx+MAX_SUBJECT_BYTES]` .
6. Let `domain_name` be `padded_header[domain_idx:domain_idx+255]` .
7. Let `is_time_exist` be 1 if `padded_header` satisfies the regex of the timestamp field.
8. Let `timestamp_str` be `padded_header[timestamp_idx:timestamp_idx+10]`.
9. If `is_time_exist` is 1, let `timestamp` be an integer parsing `timestamp_str` as a digit string. Otherwise, let `timestamp` be zero.
10. Let `is_code_exist` be 1 if `padded_header` satisfies the regex of the invitation code.
11. Let `code_str` be `padded_header[code_idx:code_idx+64]`.
12. Let `embedded_code`  be an integer parsing `code_str` as a hex string.
13. If `is_code_exist` is 1, assert that `embedded_code` is equal to `account_code`.
14. Let `account_salt` be `PoseidonHash(from_addr|0..0, account_code, 0)`.
15. Let `masked_subject` be a string that removes `code_str`, the prefix of the invitation code, and one email address from `subject`, if they appear in `subject`.
