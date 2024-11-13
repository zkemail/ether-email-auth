const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
const relayerUtils = require("@zk-email/relayer-utils");
const option = {
    include: path.join(__dirname, "../../../node_modules"),
};

// const grumpkin = require("circom-grumpkin");
jest.setTimeout(120000);
describe("Invitation Code Regex", () => {
    it("invitation code", async () => {
        const codeStr = " Code 123abc";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_invitation_code_regex.circom"
            ),
            option
        );
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        // console.log(witness);
        expect(BigInt(1)).toEqual(witness[1]);
        const prefixIdxes = relayerUtils.extractInvitationCodeIdxes(codeStr)[0];
        for (let idx = 0; idx < 256; ++idx) {
            if (idx >= prefixIdxes[0] && idx < prefixIdxes[1]) {
                expect(BigInt(paddedStr[idx])).toEqual(witness[2 + idx]);
            } else {
                expect(BigInt(0)).toEqual(witness[2 + idx]);
            }
        }
    });

    it("invitation code in the subject", async () => {
        const codeStr = "Swap 0.1 ETH to DAI code 123abc";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_invitation_code_regex.circom"
            ),
            option
        );
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        // console.log(witness);
        expect(BigInt(1)).toEqual(witness[1]);
        const prefixIdxes = relayerUtils.extractInvitationCodeIdxes(codeStr)[0];
        // const revealedStartIdx = emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8"))[0][0];
        // console.log(emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8")));
        for (let idx = 0; idx < 256; ++idx) {
            if (idx >= prefixIdxes[0] && idx < prefixIdxes[1]) {
                expect(BigInt(paddedStr[idx])).toEqual(witness[2 + idx]);
            } else {
                expect(BigInt(0)).toEqual(witness[2 + idx]);
            }
        }
    });

    it("email address and invitation code in the subject", async () => {
        const codeStr = "Send 0.1 ETH to alice@gmail.com code 123abc";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_invitation_code_regex.circom"
            ),
            option
        );
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        // console.log(witness);
        expect(BigInt(1)).toEqual(witness[1]);
        const prefixIdxes = relayerUtils.extractInvitationCodeIdxes(codeStr)[0];
        // const revealedStartIdx = emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8"))[0][0];
        // console.log(emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8")));
        for (let idx = 0; idx < 256; ++idx) {
            if (idx >= prefixIdxes[0] && idx < prefixIdxes[1]) {
                expect(BigInt(paddedStr[idx])).toEqual(witness[2 + idx]);
            } else {
                expect(BigInt(0)).toEqual(witness[2 + idx]);
            }
        }
    });

    it("prefix + invitation code in the subject", async () => {
        const codeStr = "Swap 0.1 ETH to DAI code 123abc";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_invitation_code_with_prefix_regex.circom"
            ),
            option
        );
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        // console.log(witness);
        expect(BigInt(1)).toEqual(witness[1]);
        const prefixIdxes =
            relayerUtils.extractInvitationCodeWithPrefixIdxes(codeStr)[0];
        // const revealedStartIdx = emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8"))[0][0];
        // console.log(emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8")));
        for (let idx = 0; idx < 256; ++idx) {
            if (idx >= prefixIdxes[0] && idx < prefixIdxes[1]) {
                expect(BigInt(paddedStr[idx])).toEqual(witness[2 + idx]);
            } else {
                expect(BigInt(0)).toEqual(witness[2 + idx]);
            }
        }
    });

    it("prefix + invitation code in the subject 2", async () => {
        const codeStr =
            "Re: Accept guardian request for 0x04884491560f38342C56E26BDD0fEAbb68E2d2FC Code 01eb9b204cc24c3baee11accc37d253a9c53e92b1a2cc07763475c135d575b76";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_invitation_code_with_prefix_regex.circom"
            ),
            option
        );
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        // console.log(witness);
        expect(BigInt(1)).toEqual(witness[1]);
        const prefixIdxes =
            relayerUtils.extractInvitationCodeWithPrefixIdxes(codeStr)[0];
        // const revealedStartIdx = emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8"))[0][0];
        // console.log(emailWalletUtils.extractSubstrIdxes(codeStr, readFileSync(path.join(__dirname, "../src/regexes/invitation_code.json"), "utf8")));
        for (let idx = 0; idx < 256; ++idx) {
            if (idx >= prefixIdxes[0] && idx < prefixIdxes[1]) {
                expect(BigInt(paddedStr[idx])).toEqual(witness[2 + idx]);
            } else {
                expect(BigInt(0)).toEqual(witness[2 + idx]);
            }
        }
    });


    it("invitation code in the email address should fail 1", async () => {
        const codeStr = "sepolia+code123456@sendeth.org";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_invitation_code_regex.circom"
            ),
            option
        );
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(0)).toEqual(witness[1]);
    });

    it("invitation code in the email address should fail 2", async () => {
        const codeStr = "sepoliacode123456@sendeth.org";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const circuit = await wasm_tester(
            path.join(
                __dirname,
                "./circuits/test_invitation_code_with_prefix_regex.circom"
            ),
            option
        );
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(0)).toEqual(witness[1]);
    });
});
