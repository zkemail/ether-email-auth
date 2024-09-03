const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
const relayerUtils = require("@zk-email/relayer-utils");

import { genEmailCircuitInput } from "../helpers/email_auth";
import { readFileSync } from "fs";

jest.setTimeout(1440000);
describe("Email Auth With Body Parsing", () => {
    let circuit;
    beforeAll(async () => {
        const option = {
            include: path.join(__dirname, "../../../node_modules"),
            output: path.join(__dirname, "../build"),
            recompile: true,
        };
        circuit = await wasm_tester(
            path.join(__dirname, "../src/email_auth_with_body_parsing.circom"),
            option
        );
    });

    it("Verify a sent email whose body has an email address", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_with_body_parsing_test1.eml"
        );

        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode = await relayerUtils.genAccountCode();

        const { subject_idx, ...circuitInputsRelevant } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
            });
        circuitInputsRelevant.padded_cleaned_body =
            circuitInputsRelevant.padded_body;
        const witness = await circuit.calculateWitness(circuitInputsRelevant);
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

        const timestamp = 1725116446n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand = "Send 0.1 ETH to ";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            relayerUtils.bytes2Fields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }

        const fromAddr = "zkemail.relayer.test@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(0n).toEqual(
            witness[
                1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose subject does not have an email address", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_with_body_parsing_test2.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode = await relayerUtils.genAccountCode();
        const { subject_idx, ...circuitInputsRelevant } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
            });
        circuitInputsRelevant.padded_cleaned_body =
            circuitInputsRelevant.padded_body;
        const witness = await circuit.calculateWitness(circuitInputsRelevant);
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

        const timestamp = 1725116459n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand = "Swap 1 ETH to DAI";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            relayerUtils.bytes2Fields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }

        const fromAddr = "zkemail.relayer.test@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(0n).toEqual(
            witness[
                1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose from field has a dummy email address name", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_with_body_parsing_test3.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode = await relayerUtils.genAccountCode();

        const { subject_idx, ...circuitInputsRelevant } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
            });
        circuitInputsRelevant.padded_cleaned_body =
            circuitInputsRelevant.padded_body;

        const witness = await circuit.calculateWitness(circuitInputsRelevant);
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

        const timestamp = 1725116474n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand = "Send 1 ETH to ";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            relayerUtils.bytes2Fields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }

        const fromAddr = "zkemail.relayer.test@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );
        expect(0n).toEqual(
            witness[
                1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });
});
