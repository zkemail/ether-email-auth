import { AbiFunction } from 'viem';


export interface CommandParam {
    String?: string;
    Uint?: string;
    Int?: string;
    Decimals?: string;
    EthAddr?: string;
}

export interface RelayerInput {
    contractAddress: string;
    emailAuthContractAddress: string;
    accountCode: string;
    codeExistsInEmail: boolean;
    functionAbi: AbiFunction;
    commandTemplate: string;
    commandParams: string[];
    templateId: string;
    remainingArgs: CommandParam[];
    emailAddress: string;
    subject: string;
    body: string;
    chain: string;
}