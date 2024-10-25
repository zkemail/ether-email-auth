const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
const relayerUtils = require("@zk-email/relayer-utils");
import { genEmailCircuitInput } from "../helpers/email_auth";
import { genRecipientInput } from "../helpers/recipient";
import { readFileSync } from "fs";

jest.setTimeout(1440000);
describe("Email Auth", () => {
    let circuit;
    beforeAll(async () => {
        const option = {
            include: path.join(__dirname, "../../../node_modules"),
        };
        circuit = await wasm_tester(
            path.join(__dirname, "./circuits/email_auth_with_recipient.circom"),
            option
        );
    });

    it("Verify a sent email whose subject has an email address", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_legacy_test1.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = await relayerUtils.genAccountCode();
        const {
            body_hash_idx,
            precomputed_sha,
            padded_body,
            padded_body_len,
            command_idx,
            padded_cleaned_body,
            ...emailAuthInput
        } = await genEmailCircuitInput(emailFilePath, accountCode, {
            maxHeaderLength: 1024,
            ignoreBodyHashCheck: true,
        });
        const recipientInput = await genRecipientInput(emailFilePath);
        const circuitInputs = {
            ...emailAuthInput,
            subject_email_addr_idx: recipientInput.subject_email_addr_idx,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = relayerUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = relayerUtils.publicKeyHash(
            parsedEmail.publicKey
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );
        const expectedEmailNullifier = relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );
        const timestamp = BigInt(1694989812);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 0.1 ETH to ";
        const paddedMaskedSubject = relayerUtils.padString(maskedSubject, 605);
        const maskedSubjectFields =
            relayerUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedSubjectFields.length]
        );
        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 1
            ]
        );
        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 2
            ]
        );
        const recipientEmailAddr = "alice@gmail.com";
        const emailAddrCommit = relayerUtils.emailAddrCommitWithSignature(
            recipientEmailAddr,
            parsedEmail.signature
        );
        expect(BigInt(emailAddrCommit)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 3
            ]
        );
    });

    it("Verify a sent email whose from field has a dummy email address name", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_legacy_test3.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = await relayerUtils.genAccountCode();
        const {
            body_hash_idx,
            precomputed_sha,
            padded_body,
            padded_body_len,
            command_idx,
            padded_cleaned_body,
            ...emailAuthInput
        } = await genEmailCircuitInput(emailFilePath, accountCode, {
            maxHeaderLength: 1024,
            ignoreBodyHashCheck: true,
        });
        const recipientInput = await genRecipientInput(emailFilePath);
        const circuitInputs = {
            ...emailAuthInput,
            subject_email_addr_idx: recipientInput.subject_email_addr_idx,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = relayerUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = relayerUtils.publicKeyHash(
            parsedEmail.publicKey
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );
        const expectedEmailNullifier = relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );
        const timestamp = BigInt(1696965932);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 1 ETH to ";
        const paddedMaskedSubject = relayerUtils.padString(maskedSubject, 605);
        const maskedSubjectFields =
            relayerUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedSubjectFields.length]
        );
        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 1
            ]
        );
        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 2
            ]
        );
        const recipientEmailAddr = "bob@example.com";
        const emailAddrCommit = relayerUtils.emailAddrCommitWithSignature(
            recipientEmailAddr,
            parsedEmail.signature
        );
        expect(BigInt(emailAddrCommit)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 3
            ]
        );
    });

    it("Verify a sent email whose from field has a non-English name", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_legacy_test4.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = await relayerUtils.genAccountCode();
        const {
            body_hash_idx,
            precomputed_sha,
            padded_body,
            padded_body_len,
            command_idx,
            padded_cleaned_body,
            ...emailAuthInput
        } = await genEmailCircuitInput(emailFilePath, accountCode, {
            maxHeaderLength: 1024,
            ignoreBodyHashCheck: true,
        });
        const recipientInput = await genRecipientInput(emailFilePath);
        const circuitInputs = {
            ...emailAuthInput,
            subject_email_addr_idx: recipientInput.subject_email_addr_idx,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = relayerUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = relayerUtils.publicKeyHash(
            parsedEmail.publicKey
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );
        const expectedEmailNullifier = relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );
        const timestamp = BigInt(1696967028);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 1 ETH to ";
        const paddedMaskedSubject = relayerUtils.padString(maskedSubject, 605);
        const maskedSubjectFields =
            relayerUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedSubjectFields.length]
        );
        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 1
            ]
        );
        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 2
            ]
        );
        const recipientEmailAddr = "bob@example.com";
        const emailAddrCommit = relayerUtils.emailAddrCommitWithSignature(
            recipientEmailAddr,
            parsedEmail.signature
        );
        expect(BigInt(emailAddrCommit)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedSubjectFields.length + 3
            ]
        );
    });

    it("Verify a sent email whose subject has an invitation code", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_legacy_test5.eml");
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";
        const {
            body_hash_idx,
            precomputed_sha,
            padded_body,
            padded_body_len,
            command_idx,
            padded_cleaned_body,
            ...emailAuthInput
        } = await genEmailCircuitInput(emailFilePath, accountCode, {
            maxHeaderLength: 1024,
            ignoreBodyHashCheck: true,
        });
        const recipientInput = await genRecipientInput(emailFilePath);
        const circuitInputs = {
            ...emailAuthInput,
            subject_email_addr_idx: recipientInput.subject_email_addr_idx,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = relayerUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = relayerUtils.publicKeyHash(
            parsedEmail.publicKey
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );
        const expectedEmailNullifier = relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );
        const timestamp = BigInt(1707866192);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 0.12 ETH to ";
        const paddedMaskedSubject = relayerUtils.padString(maskedSubject, 605);
        const maskedSubjectFields = relayerUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedSubjectFields.length]
        );
        expect(BigInt(1)).toEqual(
            witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 1]
        );
        expect(BigInt(1)).toEqual(
            witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 2]
        );
        const recipientEmailAddr = "alice@gmail.com";
        const emailAddrCommit = relayerUtils.emailAddrCommitWithSignature(
            recipientEmailAddr,
            parsedEmail.signature
        );
        expect(BigInt(emailAddrCommit)).toEqual(
            witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 3]
        );
    });

    it("Verify a sent email with a too large subject_email_addr_idx", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_legacy_test1.eml");
        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";
        const {
            body_hash_idx,
            precomputed_sha,
            padded_body,
            padded_body_len,
            command_idx,
            padded_cleaned_body,
            ...emailAuthInput
        } = await genEmailCircuitInput(emailFilePath, accountCode, {
            maxHeaderLength: 1024,
            ignoreBodyHashCheck: true,
        });
        const recipientInput = await genRecipientInput(emailFilePath);
        const circuitInputs = {
            ...emailAuthInput,
            subject_email_addr_idx: recipientInput.subject_email_addr_idx,
        };
        circuitInputs.subject_email_addr_idx = 605;
        async function failFn() {
            const witness = await circuit.calculateWitness(circuitInputs);
            await circuit.checkConstraints(witness);
        }
        await expect(failFn).rejects.toThrow();
    });
});
