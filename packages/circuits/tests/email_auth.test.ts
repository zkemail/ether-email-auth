const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
import * as relayerUtils from "@zk-email/relayer-utils";
import { genEmailCircuitInput } from "../helpers/email_auth";
import { readFileSync } from "fs";
import { init } from "./wasm_init";

const option = {
    include: path.join(__dirname, "../../../node_modules"),
    output: path.join(__dirname, "../build"),
    recompile: true,
};

const shaPrecomputeSelector = '<div id=3D\"[^"]*zkemail[^"]*\"[^>]*>[^<>/]+</div>';

jest.setTimeout(1440000);
describe("Email Auth", () => {
    let circuit;
    beforeAll(async () => {
        circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_email_auth.circom"
            ),
            option
        );
        await init();
    });

    it("Verify a sent email whose body has an email address", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test1.eml"
        );

        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);
        const accountCode = await relayerUtils.generateAccountCode();

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);

        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = await relayerUtils.bytesToFields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }

        const expectedPubKeyHash = await relayerUtils.publicKeyHash(
            parsedEmail.public_key
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );

        const expectedEmailNullifier = await relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );

        const timestamp = BigInt(1729865810);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand = "Send 0.1 ETH to ";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields = await
            relayerUtils.bytesToFields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }

        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = await relayerUtils.generateAccountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose body does not have an email address", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test2.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode = await relayerUtils.generateAccountCode();
        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);

        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = await relayerUtils.bytesToFields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }

        const expectedPubKeyHash = await relayerUtils.publicKeyHash(
            parsedEmail.public_key
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );

        const expectedEmailNullifier = await relayerUtils.emailNullifier(
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
            await relayerUtils.bytesToFields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }

        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = await relayerUtils.generateAccountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose from field has a dummy email address name", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test3.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode = await relayerUtils.generateAccountCode();

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);

        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = await relayerUtils.bytesToFields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }

        const expectedPubKeyHash = await relayerUtils.publicKeyHash(
            parsedEmail.public_key
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );

        const expectedEmailNullifier = await relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );

        const timestamp = BigInt(1729866032);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand = "Send 1 ETH to ";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            await relayerUtils.bytesToFields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }

        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = await relayerUtils.generateAccountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );
        expect(BigInt(0)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose body has an email address and an invitation code", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test4.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);

        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = await relayerUtils.bytesToFields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }

        const expectedPubKeyHash = await relayerUtils.publicKeyHash(
            parsedEmail.public_key
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );

        const expectedEmailNullifier = await relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );

        const timestamp = BigInt(1729866112);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand = "Send 1 ETH to ";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            await relayerUtils.bytesToFields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }

        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = await relayerUtils.generateAccountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose body has an invitation code and another hex string", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test5.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);

        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = await relayerUtils.bytesToFields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }

        const expectedPubKeyHash = await relayerUtils.publicKeyHash(
            parsedEmail.public_key
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );

        const expectedEmailNullifier = await relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );

        const timestamp = BigInt(1729866146);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand =
            "Accept guardian request for 0x04884491560f38342C56E26BDD0fEAbb68E2d2FC";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            await relayerUtils.bytesToFields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }
        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = await relayerUtils.generateAccountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose subject has Re:", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test6.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);

        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = await relayerUtils.bytesToFields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }

        const expectedPubKeyHash = await relayerUtils.publicKeyHash(
            parsedEmail.public_key
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );

        const expectedEmailNullifier = await relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );

        const timestamp = BigInt(1729866214);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand =
            "Accept guardian request for 0x04884491560f38342C56E26BDD0fEAbb68E2d2FC";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            await relayerUtils.bytesToFields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }
        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = await relayerUtils.generateAccountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email whose subject has FWD: FWD:", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test7.eml"
        );
        const emailRaw = readFileSync(emailFilePath, "utf8");
        const parsedEmail = await relayerUtils.parseEmail(emailRaw);

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);

        const domainName = "gmail.com";
        const paddedDomain = relayerUtils.padString(domainName, 255);
        const domainFields = await relayerUtils.bytesToFields(paddedDomain);
        for (let idx = 0; idx < domainFields.length; ++idx) {
            expect(BigInt(domainFields[idx])).toEqual(witness[1 + idx]);
        }

        const expectedPubKeyHash = await relayerUtils.publicKeyHash(
            parsedEmail.public_key
        );
        expect(BigInt(expectedPubKeyHash)).toEqual(
            witness[1 + domainFields.length]
        );

        const expectedEmailNullifier = await relayerUtils.emailNullifier(
            parsedEmail.signature
        );
        expect(BigInt(expectedEmailNullifier)).toEqual(
            witness[1 + domainFields.length + 1]
        );

        const timestamp = BigInt(1729866476);
        expect(timestamp).toEqual(witness[1 + domainFields.length + 2]);

        const maskedCommand =
            "Accept guardian request for 0x04884491560f38342C56E26BDD0fEAbb68E2d2FC";
        const paddedMaskedCommand = relayerUtils.padString(maskedCommand, 605);
        const maskedCommandFields =
            await relayerUtils.bytesToFields(paddedMaskedCommand);
        for (let idx = 0; idx < maskedCommandFields.length; ++idx) {
            expect(BigInt(maskedCommandFields[idx])).toEqual(
                witness[1 + domainFields.length + 3 + idx]
            );
        }
        const fromAddr = "emaiwallet.alice@gmail.com";
        const accountSalt = await relayerUtils.generateAccountSalt(fromAddr, accountCode);
        expect(BigInt(accountSalt)).toEqual(
            witness[1 + domainFields.length + 3 + maskedCommandFields.length]
        );

        expect(BigInt(1)).toEqual(
            witness[
            1 + domainFields.length + 3 + maskedCommandFields.length + 1
            ]
        );
    });

    it("Verify a sent email with a too large from_addr_idx", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test1.eml"
        );

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        circuitInputs.from_addr_idx = 640;
        async function failFn() {
            const witness = await circuit.calculateWitness(circuitInputs);
            await circuit.checkConstraints(witness);
        }
        await expect(failFn()).rejects.toThrow();
    });

    it("Verify a sent email with a too large domain_idx", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test1.eml"
        );

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        circuitInputs.domain_idx = 256;
        async function failFn() {
            const witness = await circuit.calculateWitness(circuitInputs);
            await circuit.checkConstraints(witness);
        }
        await expect(failFn()).rejects.toThrow();
    });

    it("Verify a sent email with a too large timestamp_idx", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test1.eml"
        );

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        circuitInputs.timestamp_idx = 640;
        async function failFn() {
            const witness = await circuit.calculateWitness(circuitInputs);
            await circuit.checkConstraints(witness);
        }
        await expect(failFn()).rejects.toThrow();
    });

    it("Verify a sent email with a too large code_idx", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_test1.eml"
        );

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        circuitInputs.code_idx = 768;
        async function failFn() {
            const witness = await circuit.calculateWitness(circuitInputs);
            await circuit.checkConstraints(witness);
        }
        await expect(failFn()).rejects.toThrow();
    });

    it("Verify a sent email without the forced subject", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_invalid_test1.eml"
        );

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        async function failFn() {
            const witness = await circuit.calculateWitness(circuitInputs);
            await circuit.checkConstraints(witness);
        }
        await expect(failFn()).rejects.toThrow();
    });

    it("Verify a sent email with a non-utf8 character", async () => {
        const emailFilePath = path.join(
            __dirname,
            "./emails/email_auth_invalid_test2.eml"
        );

        const accountCode =
            "0x01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";

        const circuitInputs =
            await genEmailCircuitInput(emailFilePath, accountCode, {
                maxHeaderLength: 640,
                maxBodyLength: 768,
                ignoreBodyHashCheck: false,
                shaPrecomputeSelector,
            });
        async function failFn() {
            const witness = await circuit.calculateWitness(circuitInputs);
            await circuit.checkConstraints(witness);
        }
        await expect(failFn()).rejects.toThrow();
    });
});
