// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployRecoveryController.s.sol";
import {StructHelper} from "../helpers/StructHelper.sol";

contract DeploySimpleWalletScriptTest is StructHelper {
    function setUp() public override {
        resetEnviromentVariables();
        super.setUp();
        vm.setEnv(
            "PRIVATE_KEY",
            "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
        );
        vm.setEnv("DKIM_SIGNER", "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0");
        vm.setEnv("INITIAL_OWNER", "0x70997970C51812dc3A010C7d01b50e0d17dc79C8");

        vm.setEnv("DKIM", vm.toString(address(dkim)));
        vm.setEnv("VERIFIER", vm.toString(address(verifier)));
        vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(emailAuth)));
        vm.setEnv("SIMPLE_WALLET_IMPL", vm.toString(address(simpleWalletImpl)));
    }

    function test_run() public {
        skipIfZkSync();

        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_dkim() public {
        skipIfZkSync();

        vm.setEnv("DKIM", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_verifier() public {
        skipIfZkSync();

        vm.setEnv("VERIFIER", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_email_auth() public {
        skipIfZkSync();

        vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_simple_wallet() public {
        skipIfZkSync();

        vm.setEnv("SIMPLE_WALLET_IMPL", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }
}
