require("dotenv").config();
import emailAuthAbi from "../abis/EmailAuth.json";
import emitEmailCommandAbi from "../abis/EmitEmailCommand.json";
import {
    encodeAbiParameters,
    parseAbiParameters,
} from "viem";
import { AbiFunction } from 'viem';
import { RelayerInput, CommandParam } from './types';

if (!process.env.EMIT_EMAIL_COMMAND_ADDR) {
    throw new Error('EMIT_EMAIL_COMMAND_ADDR is not defined');
}
const emitEmailCommandAddr: string = process.env.EMIT_EMAIL_COMMAND_ADDR;

enum CommandTypes {
    String,
    Uint,
    Int,
    Decimals,
    EthAddr,
}

async function constructInputToRelayer(commandType: CommandTypes, commandValue: string | number | bigint) {
    let commandParams: CommandParam[] = [];
    switch (commandType) {
        case CommandTypes.String:
            commandParams.push({ String: commandValue as string });
            break;
        case CommandTypes.Uint:
            commandParams.push({ Uint: commandValue.toString() });
            break;
        case CommandTypes.Int:
            commandParams.push({ Int: commandValue.toString() });
            break;
        case CommandTypes.Decimals:
            commandParams.push({ Decimals: ((commandValue as bigint) * (10n ** 18n)).toString() });
            break;
        case CommandTypes.EthAddr:
            commandParams.push({ EthAddr: commandValue as string });
            break;
        default:
            throw new Error('Unsupported command type');
    }
}