const circom_tester = require("circom_tester");
const wasm_tester = circom_tester.wasm;
import * as path from "path";
const relayerUtils = require("@zk-email/relayer-utils");

// const grumpkin = require("circom-grumpkin");
jest.setTimeout(120000);
describe("Forced Subject Regex", () => {
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
                "./circuits/test_forced_subject_regex.circom"
            ),
            option
        );
    });

    it("forced subject valid case 1", async () => {
        const codeStr = "subject:ZK Email\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(1n).toEqual(witness[1]);
    });

    it("forced subject valid case 2", async () => {
        const codeStr = "subject:Re: ZK Email\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(1n).toEqual(witness[1]);
    });

    it("forced subject valid case 3", async () => {
        const codeStr = "subject:ZK Email Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(1n).toEqual(witness[1]);
    });

    it("forced subject valid case 4", async () => {
        const codeStr = "subject:Re: ZK Email Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(1n).toEqual(witness[1]);
    });

    it("forced subject valid case 5", async () => {
        const codeStr = "from: a@gmail.com\r\nsubject:Re: ZK Email Command X\r\nto:b@gmail.com";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(1n).toEqual(witness[1]);
    });
});
