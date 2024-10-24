// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Defender, ApprovalProcessResponse} from "openzeppelin-foundry-upgrades/Defender.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import "../test/helpers/SimpleWallet.sol";

contract Deploy is Script {
    function run() external {
        ApprovalProcessResponse memory upgradeApprovalProcess = Defender
            .getUpgradeApprovalProcess();

        if (upgradeApprovalProcess.via == address(0)) {
            revert(
                string.concat(
                    "Upgrade approval process with id ",
                    upgradeApprovalProcess.approvalProcessId,
                    " has no assigned address"
                )
            );
        }

        Options memory opts;
        opts.defender.useDefenderDeploy = true;

        address initOwner = upgradeApprovalProcess.via;
        // address controller = vm.envAddress("CONTROLLER");
        address controller = address(1);

        address proxyAddress = Upgrades.deployUUPSProxy(
            "SimpleWallet.sol",
            abi.encodeCall(SimpleWallet.initialize, (initOwner, controller)),
            opts
        );
        ERC1967Proxy proxy = ERC1967Proxy(payable(proxyAddress));
        console.log("SimpleWallet deployed at: %s", address(proxy));
    }
}
