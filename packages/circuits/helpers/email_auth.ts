import fs from "fs";
import { promisify } from "util";
import * as relayerUtils from "@zk-email/relayer-utils";

export async function genEmailCircuitInput(
    emailFilePath: string,
    accountCode: string,
    options?: {
        shaPrecomputeSelector?: string;
        maxHeaderLength?: number;
        maxBodyLength?: number;
        ignoreBodyHashCheck?: boolean;
    }
): Promise<{
    padded_header: string[];
    public_key: string[];
    signature: string[];
    padded_header_len: string;
    account_code: string;
    from_addr_idx: number;
    subject_idx: number;
    domain_idx: number;
    timestamp_idx: number;
    code_idx: number;
    body_hash_idx: number;
    precomputed_sha: string[];
    padded_body: string[];
    padded_body_len: string;
    command_idx: number;
    padded_cleaned_body: string[];
}> {
    const emailRaw = await promisify(fs.readFile)(emailFilePath, "utf8");
    const jsonStr = await relayerUtils.generateEmailCircuitInput(
        emailRaw,
        accountCode,
        {
            ignore_body_hash_check: options?.ignoreBodyHashCheck,
            max_header_length: options?.maxHeaderLength,
            max_body_length: options?.maxBodyLength,
            sha_precompute_selector: options?.shaPrecomputeSelector,
        }
    );
    return JSON.parse(jsonStr);
}
