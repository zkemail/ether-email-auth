import * as relayerUtils from "@zk-email/relayer-utils";

let inited = false;

export async function init() {
    if (!inited) {
        await relayerUtils.init();
        inited = true;
    }
}
