import fs from "fs";
import { promisify } from "util";
import path from "path";
const relayerUtils = require("@zk-email/relayer-utils");

export async function genRecipientInputLegacy(emailFilePath: string): Promise<{
  subject_email_addr_idx: number;
  rand: string;
}> {
  const emailRaw = await promisify(fs.readFile)(emailFilePath, "utf8");
  const parsedEmail = await relayerUtils.parseEmail(emailRaw);
  const subjectEmailIdxes = relayerUtils.extractSubjectAllIdxes(
    parsedEmail.canonicalizedHeader
  )[0];
  const subject = parsedEmail.canonicalizedHeader.slice(
    subjectEmailIdxes[0],
    subjectEmailIdxes[1]
  );
  let subjectEmailAddrIdx = 0;
  try {
    subjectEmailAddrIdx = relayerUtils.extractEmailAddrIdxes(subject)[0][0];
  } catch (e) {
    console.log("No email address in subject");
    subjectEmailAddrIdx = 0;
  }
  const rand = relayerUtils.extractRandFromSignature(parsedEmail.signature);
  return {
    subject_email_addr_idx: subjectEmailAddrIdx,
    rand: rand,
  };
}

export async function genRecipientInput(command: string, signature: string): Promise<{
  command_email_addr_idx: number;
  rand: string;
}> {
  let commandEmailAddrIdx = 0;
  try {
    commandEmailAddrIdx = relayerUtils.extractEmailAddrIdxes(command)[0][0];
  } catch (e) {
    console.log("No email address in command");
  }
  const rand = relayerUtils.extractRandFromSignature(signature);
  return {
    command_email_addr_idx: commandEmailAddrIdx,
    rand: rand,
  };
}