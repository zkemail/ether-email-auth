import fs from "fs";
import { promisify } from "util";
import { generateCircuitInputs } from "@zk-email/helpers/dist/input-helpers";
const emailWalletUtils = require("../../utils");


export async function genRecipientInput(emailFilePath: string):
    Promise<{
        subject_email_addr_idx: number,
        rand: string
    }> {
    const emailRaw = await promisify(fs.readFile)(emailFilePath, "utf8");
    const parsedEmail = await emailWalletUtils.parseEmail(emailRaw);
    const subjectEmailIdxes = emailWalletUtils.extractSubjectAllIdxes(parsedEmail.canonicalizedHeader)[0];
    const subject = parsedEmail.canonicalizedHeader.slice(subjectEmailIdxes[0], subjectEmailIdxes[1]);
    let subjectEmailAddrIdx = 0;
    try {
        subjectEmailAddrIdx = emailWalletUtils.extractEmailAddrIdxes(subject)[0][0];
    } catch (e) {
        console.log("No email address in subject");
        subjectEmailAddrIdx = 0;
    }
    const rand = emailWalletUtils.extractRandFromSignature(parsedEmail.signature);
    return {
        subject_email_addr_idx: subjectEmailAddrIdx,
        rand: rand
    }
}
