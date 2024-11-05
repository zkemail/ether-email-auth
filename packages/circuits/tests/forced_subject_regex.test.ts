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

    it("forced subject valid case", async () => {
        const codeStr = "subject:[Reply Needed]\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with re", async () => {
        const codeStr = "subject:re: [Reply Needed]\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with RE", async () => {
        const codeStr = "subject:RE: [Reply Needed]\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with Re", async () => {
        const codeStr = "subject:Re: [Reply Needed]\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with fwd", async () => {
        const codeStr = "subject:fwd: [Reply Needed]\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with FWD", async () => {
        const codeStr = "subject:FWD: [Reply Needed]\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });


    it("forced subject valid case with Fwd", async () => {
        const codeStr = "subject:Fwd: [Reply Needed]\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });


    it("forced subject valid case with following string", async () => {
        const codeStr = "subject:[Reply Needed] Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with re with following string", async () => {
        const codeStr = "subject:re: [Reply Needed] Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with RE with following string", async () => {
        const codeStr = "subject:RE: [Reply Needed] Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with Re with following string", async () => {
        const codeStr = "subject:Re: [Reply Needed] Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with fwd with following string", async () => {
        const codeStr = "subject:fwd: [Reply Needed] Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject valid case with FWD with following string", async () => {
        const codeStr = "subject:FWD: [Reply Needed] Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });


    it("forced subject valid case with Fwd with following string", async () => {
        const codeStr = "subject:Fwd: [Reply Needed] Command X\r\n";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });


    it("forced subject valid case with other fields", async () => {
        const codeStr = "from: a@gmail.com\r\nsubject:Re: [Reply Needed] Command X\r\nto:b@gmail.com";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });


    it("forced subject valid case with multiple prefixes", async () => {
        const codeStr = "from: a@gmail.com\r\nsubject:Re: Re: Re: Re: Re: [Reply Needed] Command X\r\nto:b@gmail.com";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(1)).toEqual(witness[1]);
    });

    it("forced subject invalid case", async () => {
        const codeStr = "from: a@gmail.com\r\nsubject:Re: [Reply Unneeded] Command X\r\nto:b@gmail.com";
        const paddedStr = relayerUtils.padString(codeStr, 256);
        const circuitInputs = {
            msg: paddedStr,
        };
        const witness = await circuit.calculateWitness(circuitInputs);
        await circuit.checkConstraints(witness);
        expect(BigInt(0)).toEqual(witness[1]);
    });
});
