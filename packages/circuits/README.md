# Circuit Architecture
## Circom Circuits
### Main Circuits

We provide one main circuit as follows.

#### `email_auth.circom`
A circuit to verify that a message in the subject is authorized by a user of an account salt, derived from an email address in the From field and a random field value called account code.

It takes as input the following data:
1. a padded email header `padded_header`.
2. an RSA public key `public_key`.
3. an RSA signature `signature`.
4. the bytes of the padded email header `padded_header_len`.
5. the sender's account code `account_code`.
6. a starting position of the From field in the email header `from_addr_idx`.
7. a starting position of the Subject field in the email header `subject_idx`.
8. a starting position of the email domain in the email address of the From field `domain_idx`.
10. a starting position of the timestamp in the email header `timestamp_idx`.
11. a starting position of the invitation code in the email header `code_idx`.

Its instances are as follows:
1. an email domain `domain_name`.
2. a poseidon hash of the RSA public key `public_key_hash`.
3. an nullifier of the email `email_nullifier`.
4. a timestamp in the email header `timestamp`.
5. a masked subject where a character either in the email address or in the invitation code is replaced with zero  `masked_subject_str`.
6. an account salt `account_salt`.
7. a flag whether the email header contains the invitation code `is_code_exist`.

## How to Use
### Build circuits
`yarn && yarn build`

### Run tests
At `packages/circuits`, make a `build` directory, download the zip file from the following link, and place its unziped directory under `build`.
https://drive.google.com/file/d/1ky3XyabnBFwcyBoWBimhoePT9kbFyEBR/view?usp=sharing

Then, move `email_auth.zkey` in the unzipped directory `params` to `build`. 

Then run the following command.
`yarn test`

### Generate proving keys and verifier contracts for main circuits
`yarn dev-setup`

