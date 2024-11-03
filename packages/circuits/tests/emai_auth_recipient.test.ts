const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
const relayerUtils = require("@zk-email/relayer-utils");
import { genEmailCircuitInput } from "../helpers/email_auth";
import { readFileSync } from "fs";
import { genRecipientInput } from "../helpers/recipient";

const option = {
    include: path.join(__dirname, "../../../node_modules"),
    output: path.join(__dirname, "../build"),
    recompile: true,
};

jest.setTimeout(1440000);
describe("Email Auth with Recipient", () => {
    let circuit;
    beforeAll(async () => {
        circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_email_auth_with_recipient.circom"
            ),
            option
        );
    });

    it("Verify a sent email whose body has an email address with the recipient's email address commitment", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test1.eml"
        );

        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);
        console.log(parsedEmail);
        const accountCode = await relayerUtils.genAccountCode();

        const {
            subject_idx,
            ...emailAuthInput
        } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector: '(<(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)? (=\r\n)?i(=\r\n)?d(=\r\n)?=3D(=\r\n)?"(=\r\n)?[^"]*(=\r\n)?z(=\r\n)?k(=\r\n)?e(=\r\n)?m(=\r\n)?a(=\r\n)?i(=\r\n)?l(=\r\n)?[^"]*(=\r\n)?"(=\r\n)?[^>]*(=\r\n)?>(=\r\n)?)(=\r\n)?([^<>/]+)(<(=\r\n)?/(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)?>(=\r\n)?)',
            });
        const command = "Send 0.1 ETH to alice@gmail.com";
        const recipientInput = await genRecipientInput(command, parsedEmail.signature);
        const circuitInputs = {
            ...emailAuthInput,
            command_email_addr_idx: recipientInput.command_email_addr_idx,
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

        const timestamp = BigInt(1729865810);
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

        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );

        const recipientEmailAddr = "alice@gmail.com";
        const emailAddrCommit = relayerUtils.emailAddrCommitWithSignature(
            recipientEmailAddr,
            parsedEmail.signature
        );
        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 2
            ]
        );
        expect(BigInt(emailAddrCommit)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 3
            ]
        );
    });

    it("Verify a sent email whose body has no email address with the recipient's email address commitment", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test2.eml"
        );

        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);
        console.log(parsedEmail);
        const accountCode = await relayerUtils.genAccountCode();

        const {
            subject_idx,
            ...emailAuthInput
        } =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector: '(<(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)? (=\r\n)?i(=\r\n)?d(=\r\n)?=3D(=\r\n)?"(=\r\n)?[^"]*(=\r\n)?z(=\r\n)?k(=\r\n)?e(=\r\n)?m(=\r\n)?a(=\r\n)?i(=\r\n)?l(=\r\n)?[^"]*(=\r\n)?"(=\r\n)?[^>]*(=\r\n)?>(=\r\n)?)(=\r\n)?([^<>/]+)(<(=\r\n)?/(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)?>(=\r\n)?)',
            });
        const command = "Swap 1 ETH to DAI";
        const recipientInput = await genRecipientInput(command, parsedEmail.signature);
        const circuitInputs = {
            ...emailAuthInput,
            command_email_addr_idx: recipientInput.command_email_addr_idx,
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

        const timestamp = BigInt(1729865832);
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

        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = relayerUtils.accountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );

        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 2
            ]
        );
        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 3
            ]
        );
    });

});
