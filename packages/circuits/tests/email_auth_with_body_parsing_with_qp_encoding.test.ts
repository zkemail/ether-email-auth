const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
const relayerUtils = require("@zk-email/relayer-utils");

import { genEmailCircuitInput } from "../helpers/email_auth";
import { readFileSync } from "fs";

jest.setTimeout(1440000);
describe("Email Auth With Body Parsing (QP Encoded)", () => {
    let circuit;
    beforeAll(async () => {
        const option = {
            include: path.join(__dirname, "../../../node_modules"),
            output: path.join(__dirname, "../build"),
            recompile: true,
        };
        circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_email_auth_with_body_parsing_with_qp_encoding.circom"
            ),
            option
        );
    });

    // it("Verify a sent email whose from field has a non-English name", async () => {
    //     const emailFilePath = path.join(
    //         __dirname,
    //         "./emails/email_auth_with_body_parsing_test4.eml"
    //     );
    //     const emailRaw = readFileSync(emailFilePath, "utf8");
    //     const parsedEmail = await relayerUtils.parseEmail(emailRaw);
    //     console.log(parsedEmail.canonicalizedHeader);
    //     const accountCode = await relayerUtils.genAccountCode();
    //     const circuitInputs = await genEmailAuthInput(
    //         emailFilePath,
    //         accountCode
    //     );
    //     const witness = await circuit.calculateWitness(circuitInputs);
    //     await circuit.checkConstraints(witness);
    //     const domainName = "gmail.com";
    //     const paddedDomain = relayerUtils.padString(domainName, 255);
    //     const domainFields = relayerUtils.bytes2Fields(paddedDomain);
    //     for (let idx = 0; idx < domainFields.length; ++idx) {
    //         expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
    //     }
    //     const expectedPubKeyHash = relayerUtils.publicKeyHash(
    //         parsedEmail.publicKey
    //     );
    //     expect(BigInt(expectedPubKeyHash)).toEqual(
    //         witness[1 + domainFields.length]
    //     );
    //     const expectedEmailNullifier = relayerUtils.emailNullifier(
    //         parsedEmail.signature
    //     );
    //     expect(BigInt(expectedEmailNullifier)).toEqual(
    //         witness[1 + domainFields.length + 1]
    //     );
    //     const timestamp = 1725334030n;
    //     expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);
    //     const maskedSubject = "Send 1 ETH to ";
    //     const paddedMaskedSubject = relayerUtils.padString(maskedSubject, 605);
    //     const maskedSubjectFields =
    //         relayerUtils.bytes2Fields(paddedMaskedSubject);
    //     for (let idx = 0; idx < maskedSubjectFields.length; ++idx) {
    //         expect(BigInt(maskedSubjectFields[idx])).toEqual(
    //             witness[1 + domainFields.length + 3 + idx]
    //         );
    //     }
    //     const fromAddr = "suegamisora@gmail.com";
    //     const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
    //     expect(BigInt(accountSalt)).toEqual(
    //         witness[1 + domainFields.length + 3 + maskedSubjectFields.length]
    //     );
    //     expect(0n).toEqual(
    //         witness[
    //             1 + domainFields.length + 3 + maskedSubjectFields.length + 1
    //         ]
    //     );
    // });

    it("Verify a sent email whose body has an email address and an invitation code", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_with_body_parsing_test4.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const { subject_idx, ...circuitInputsRelevant } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
            });
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

        const timestamp = 1725334030n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand = "Send 0.12 ETH to ";
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

        expect(1n).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose body has an invitation code", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_with_body_parsing_test5.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const { subject_idx, ...circuitInputsRelevant } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
            });
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

        const timestamp = 1725334056n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand =
            "Accept guardian request for 0x04884491560f38342C56E26BDD0fEAbb68E2d2FC";
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

        expect(1n).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose body has an invitation code with sha precompute string", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_with_body_parsing_test5.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const { subject_idx, ...circuitInputsRelevant } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector: '(<(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)? (=\r\n)?i(=\r\n)?d(=\r\n)?=3D(=\r\n)?"(=\r\n)?[^"]*(=\r\n)?z(=\r\n)?k(=\r\n)?e(=\r\n)?m(=\r\n)?a(=\r\n)?i(=\r\n)?l(=\r\n)?[^"]*(=\r\n)?"(=\r\n)?[^>]*(=\r\n)?>(=\r\n)?)(=\r\n)?([^<>/]+)(<(=\r\n)?/(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)?>(=\r\n)?)',
            });
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

        const timestamp = 1725334056n;
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand =
            "Accept guardian request for 0x04884491560f38342C56E26BDD0fEAbb68E2d2FC";
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

        expect(1n).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });
});
