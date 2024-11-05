import fs from "fs";
import { promisify } from "util";
const relayerUtils = require("@zk-email/relayer-utils");

export async function genEmailAuthInput(
  emailFilePath: string,
  accountCode: string
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
}> {
  const emailRaw = await promisify(fs.readFile)(emailFilePath, "utf8");
  const jsonStr = await relayerUtils.genEmailAuthInput(emailRaw, accountCode);
  return JSON.parse(jsonStr);
}
