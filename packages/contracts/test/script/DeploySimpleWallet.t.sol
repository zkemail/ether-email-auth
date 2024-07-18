// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import { Deploy } from "../../script/DeployCommons.s.sol";
import "../helpers/StructHelper.sol";

contract DeploySimpleWalletTest is StructHelper {
    function setUp() public override {
        super.setUp();
        vm.setEnv(
            "PRIVATE_KEY", 
            "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
        );
        vm.setEnv(
            "SIGNER", 
            "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0"
        );
 
        vm.setEnv(
            "DKIM", 
            vm.toString(address(dkim))
        );
        vm.setEnv(
            "VERIFIER", 
            vm.toString(address(verifier))
        );
        vm.setEnv(
            "EMAIL_AUTH_IMPL", 
            vm.toString(address(emailAuth))
        );
        vm.setEnv(
            "SIMPLE_WALLET_IMPL", 
            vm.toString(address(simpleWalletImpl))
        );
    }

    function test_run() public {
        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_dkim() public {
        vm.setEnv("DKIM", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_verifier() public {
        vm.setEnv("VERIFIER", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_email_auth() public {
        vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }

    function test_run_no_simple_wallet() public {
        vm.setEnv("SIMPLE_WALLET_IMPL", vm.toString(address(0)));
        Deploy deploy = new Deploy();
        deploy.run();
    }
}
