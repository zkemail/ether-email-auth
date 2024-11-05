/**
 * 
 * This script is for generating input for the main circuit.
 * 
 */


import { program } from "commander";
import fs from "fs";
import { promisify } from "util";
import { genEmailAuthInput } from "../helpers/email_auth";
import path from "path";
const snarkjs = require("snarkjs");

program
    .requiredOption(
        "--email-file <string>",
        "Path to an email file"
    )
    .requiredOption(
        "--account-code <string>",
        "The account code for the sender's email address"
    )
    .requiredOption(
        "--input-file <string>",
        "Path of a json file to write the generated input"
    )
    .option("--silent", "No console logs")
    .option("--prove", "Also generate proof");

program.parse();
const args = program.opts();

function log(...message: any) {
    if (!args.silent) {
        console.log(...message);
    }
}

async function generate() {
    if (!args.inputFile.endsWith(".json")) {
        throw new Error("--input file path arg must end with .json");
    }

    log("Generating Inputs for:", args);

    const circuitInputs = await genEmailAuthInput(args.emailFile, args.accountCode);
    log("\n\nGenerated Inputs:", circuitInputs, "\n\n");

    await promisify(fs.writeFile)(args.inputFile, JSON.stringify(circuitInputs, null, 2));

    log("Inputs written to", args.inputFile);

    if (args.prove) {
        const dir = path.dirname(args.inputFile);
        const { proof, publicSignals } = await snarkjs.groth16.fullProve(circuitInputs, path.join(dir, "email_auth.wasm"), path.join(dir, "email_auth.zkey"), console);
        await promisify(fs.writeFile)(path.join(dir, "email_auth_proof.json"), JSON.stringify(proof, null, 2));
        await promisify(fs.writeFile)(path.join(dir, "email_auth_public.json"), JSON.stringify(publicSignals, null, 2));
        log("✓ Proof for email auth circuit generated");
    }
    process.exit(0);
}

generate().catch((err) => {
    console.error("Error generating inputs", err);
    process.exit(1);
});
