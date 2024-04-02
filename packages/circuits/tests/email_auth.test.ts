const utils = require("../../utils");
const ff = require('ffjavascript');
const stringifyBigInts = ff.utils.stringifyBigInts;
const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
const p = "21888242871839275222246405745257275088548364400416034343698204186575808495617";
const field = new ff.F1Field(p);
const emailWalletUtils = require("../../utils");
const option = {
    include: path.join(__dirname, "../../../node_modules")
};
import { genEmailAuthInput } from "../helpers/email_auth";
import { readFileSync } from "fs";

jest.setTimeout(1440000);
describe("Email Auth", () => {
    it("Verify a sent email whose subject has an email address", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_test1.eml");
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = await emailWalletUtils.genAccountCode();
        const circuitInputs = await genEmailAuthInput(emailFilePath, accountCode);
        const circuit = await wasm_tester(path.join(__dirname, "../src/email_auth.circom"), option);
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = emailWalletUtils.padString(domainName, 255);
        const domainFields = emailWalletUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = emailWalletUtils.publicKeyHash(parsedEmail.publicKey);
        expect(BigInt(expectedPubKeyHash)).toEqual(witness[1 + domainFields.length]);
        const expectedEmailNullifier = emailWalletUtils.emailNullifier(parsedEmail.signature);
        expect(BigInt(expectedEmailNullifier)).toEqual(witness[1 + domainFields.length + 1]);
        const timestamp = 1694989812n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 0.1 ETH to ";
        const paddedMaskedSubject = emailWalletUtils.padString(maskedSubject, 605);
        const maskedSubjectFields = emailWalletUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(witness[1 + domainFields.length + 3 + idx]);
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = emailWalletUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length]);
        expect(0n).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 1]);
    });

    it("Verify a sent email whose subject does not have an email address", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_test2.eml");
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = await emailWalletUtils.genAccountCode();
        const circuitInputs = await genEmailAuthInput(emailFilePath, accountCode);
        const circuit = await wasm_tester(path.join(__dirname, "../src/email_auth.circom"), option);
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = emailWalletUtils.padString(domainName, 255);
        const domainFields = emailWalletUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = emailWalletUtils.publicKeyHash(parsedEmail.publicKey);
        expect(BigInt(expectedPubKeyHash)).toEqual(witness[1 + domainFields.length]);
        const expectedEmailNullifier = emailWalletUtils.emailNullifier(parsedEmail.signature);
        expect(BigInt(expectedEmailNullifier)).toEqual(witness[1 + domainFields.length + 1]);
        const timestamp = 1696964295n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Swap 1 ETH to DAI";
        const paddedMaskedSubject = emailWalletUtils.padString(maskedSubject, 605);
        const maskedSubjectFields = emailWalletUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(witness[1 + domainFields.length + 3 + idx]);
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = emailWalletUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length]);
        expect(0n).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 1]);
    });

    it("Verify a sent email whose from field has a dummy email address name", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_test3.eml");
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = await emailWalletUtils.genAccountCode();
        const circuitInputs = await genEmailAuthInput(emailFilePath, accountCode);
        const circuit = await wasm_tester(path.join(__dirname, "../src/email_auth.circom"), option);
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = emailWalletUtils.padString(domainName, 255);
        const domainFields = emailWalletUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = emailWalletUtils.publicKeyHash(parsedEmail.publicKey);
        expect(BigInt(expectedPubKeyHash)).toEqual(witness[1 + domainFields.length]);
        const expectedEmailNullifier = emailWalletUtils.emailNullifier(parsedEmail.signature);
        expect(BigInt(expectedEmailNullifier)).toEqual(witness[1 + domainFields.length + 1]);
        const timestamp = 1696965932n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 1 ETH to ";
        const paddedMaskedSubject = emailWalletUtils.padString(maskedSubject, 605);
        const maskedSubjectFields = emailWalletUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(witness[1 + domainFields.length + 3 + idx]);
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = emailWalletUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length]);
        expect(0n).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 1]);
    });

    it("Verify a sent email whose from field has a non-English name", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_test4.eml");
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = await emailWalletUtils.genAccountCode();
        const circuitInputs = await genEmailAuthInput(emailFilePath, accountCode);
        const circuit = await wasm_tester(path.join(__dirname, "../src/email_auth.circom"), option);
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = emailWalletUtils.padString(domainName, 255);
        const domainFields = emailWalletUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = emailWalletUtils.publicKeyHash(parsedEmail.publicKey);
        expect(BigInt(expectedPubKeyHash)).toEqual(witness[1 + domainFields.length]);
        const expectedEmailNullifier = emailWalletUtils.emailNullifier(parsedEmail.signature);
        expect(BigInt(expectedEmailNullifier)).toEqual(witness[1 + domainFields.length + 1]);
        const timestamp = 1696967028n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 1 ETH to ";
        const paddedMaskedSubject = emailWalletUtils.padString(maskedSubject, 605);
        const maskedSubjectFields = emailWalletUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(witness[1 + domainFields.length + 3 + idx]);
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = emailWalletUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length]);
        expect(0n).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 1]);
    });

    it("Verify a sent email whose subject has an email address and an invitation code", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_test5.eml");
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
        console.log(parsedEmail.canonicalizedHeader);
        const accountCode = "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";
        const circuitInputs = await genEmailAuthInput(emailFilePath, accountCode);
        const circuit = await wasm_tester(path.join(__dirname, "../src/email_auth.circom"), option);
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = emailWalletUtils.padString(domainName, 255);
        const domainFields = emailWalletUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = emailWalletUtils.publicKeyHash(parsedEmail.publicKey);
        expect(BigInt(expectedPubKeyHash)).toEqual(witness[1 + domainFields.length]);
        const expectedEmailNullifier = emailWalletUtils.emailNullifier(parsedEmail.signature);
        expect(BigInt(expectedEmailNullifier)).toEqual(witness[1 + domainFields.length + 1]);
        const timestamp = 1707866192n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Send 0.12 ETH to ";
        const paddedMaskedSubject = emailWalletUtils.padString(maskedSubject, 605);
        const maskedSubjectFields = emailWalletUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(witness[1 + domainFields.length + 3 + idx]);
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = emailWalletUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length]);
        expect(1n).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 1]);
    });

    it("Verify a sent email whose subject has an invitation code", async () => {
        const emailFilePath = path.join(__dirname, "./emails/email_auth_test6.eml");
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
        const accountCode = "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";
        const circuitInputs = await genEmailAuthInput(emailFilePath, accountCode);
        const circuit = await wasm_tester(path.join(__dirname, "../src/email_auth.circom"), option);
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        const domainName = "gmail.com";
        const paddedDomain = emailWalletUtils.padString(domainName, 255);
        const domainFields = emailWalletUtils.bytes2Fields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }
        const expectedPubKeyHash = emailWalletUtils.publicKeyHash(parsedEmail.publicKey);
        expect(BigInt(expectedPubKeyHash)).toEqual(witness[1 + domainFields.length]);
        const expectedEmailNullifier = emailWalletUtils.emailNullifier(parsedEmail.signature);
        expect(BigInt(expectedEmailNullifier)).toEqual(witness[1 + domainFields.length + 1]);
        const timestamp = 1711992080n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
        const maskedSubject = "Re: Accept guardian request for 0x04884491560f38342C56E26BDD0fEAbb68E2d2FC";
        const paddedMaskedSubject = emailWalletUtils.padString(maskedSubject, 605);
        const maskedSubjectFields = emailWalletUtils.bytes2Fields(paddedMaskedSubject);
        for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
            expect(BigInt(maskedSubjectFields[idx])).toEqual(witness[1 + domainFields.length + 3 + idx]);
        }
        const fromAddr = "suegamisora@gmail.com";
        const accountSalt = emailWalletUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length]);
        expect(1n).toEqual(witness[1 + domainFields.length + 3 + maskedSubjectFields.length + 1]);
    });
});