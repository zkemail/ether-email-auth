import fs from "fs";
import { promisify } from "util";
import { generateCircuitInputs } from "@zk-email/helpers/dist/input-helpers";
const emailWalletUtils = require("../../utils");


export async function genEmailAuthInput(emailFilePath: string, accountCode: string):
  Promise<{
    padded_header: string[],
    public_key: string[],
    signature: string[],
    padded_header_len: string,
    account_code: string,
    from_addr_idx: number,
    subject_idx: number,
    domain_idx: number,
    timestamp_idx: number,
    code_idx: number
  }> {
  const emailRaw = await promisify(fs.readFile)(emailFilePath, "utf8");
  const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
  const emailCircuitInputs = generateCircuitInputs({
    body: Buffer.from(""),
    message: Buffer.from(parsedEmail.canonicalizedHeader),
    bodyHash: "",
    rsaSignature: BigInt(parsedEmail.signature),
    rsaPublicKey: BigInt(parsedEmail.publicKey),
    maxMessageLength: 1024,
    maxBodyLength: 64,
    ignoreBodyHashCheck: true
  });
  const from_addr_idxes = emailWalletUtils.extractFromAddrIdxes(parsedEmail.canonicalizedHeader)[0];
  const fromEmailAddrPart = parsedEmail.canonicalizedHeader.slice(from_addr_idxes[0], from_addr_idxes[1]);
  const subject_idx = emailWalletUtils.extractSubjectAllIdxes(parsedEmail.canonicalizedHeader)[0][0];
  const domainIdx = emailWalletUtils.extractEmailDomainIdxes(fromEmailAddrPart)[0][0];
  const timestampIdx = emailWalletUtils.extractTimestampIdxes(parsedEmail.canonicalizedHeader)[0][0];
  let codeIdx = 0;
  try {
    codeIdx = emailWalletUtils.extractInvitationCodeIdxes(parsedEmail.canonicalizedHeader)[0][0];
  } catch (e) {
    console.log("No invitation code in header");
  }
  return {
    padded_header: emailCircuitInputs.in_padded,
    public_key: emailCircuitInputs.pubkey,
    signature: emailCircuitInputs.signature,
    padded_header_len: emailCircuitInputs.in_len_padded_bytes,
    account_code: accountCode,
    from_addr_idx: from_addr_idxes[0],
    subject_idx: subject_idx,
    domain_idx: domainIdx,
    timestamp_idx: timestampIdx,
    code_idx: codeIdx,
  };
}
