// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployRecoveryController.s.sol";
import {StructHelper} from "../helpers/StructHelper.sol";

contract DeployRecoveryControllerScriptTest is StructHelper {
    function setUp() public override {
        resetEnviromentVariables();
        super.setUp();
        vm.setEnv(
            "PRIVATE_KEY",
            "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
        );
        vm.setEnv("DKIM_SIGNER", "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0");
        vm.setEnv(
            "INITIAL_OWNER",
            "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
        );
    }

    function test_run() public {
        skipIfZkSync();

        Deploy deploy = new Deploy();
        deploy.run();
        vm.setEnv("DKIM", "0xedF4bB8f2d504dDCe967A72cb738F8F3E2e44374");
        vm.setEnv("VERIFIER", "0x38323919eFb82A1f1a04D863BbBe12925cb93f2D");
        vm.setEnv(
            "EMAIL_AUTH_IMPL",
            "0x4393aB187b8B509d153681383a8aB26593BfA8d6"
        );
        vm.setEnv(
            "RECOVERY_CONTROLLER",
            "0x064c9B191E626618b787e77630995bDcEbAD69F6"
        );
        vm.setEnv(
            "SIMPLE_WALLET",
            "0x300f752d60986Dd7b7b41795e46b3326D8127dCb"
        );
        deploy.deployECDSAOwnedDKIMRegistry(
            vm.addr(vm.envUint("PRIVATE_KEY")),
            vm.envAddress("DKIM_SIGNER")
        );
        vm.setEnv("ECDSA_DKIM", "0x6600f69ba900BFD830bE1a8985ED59A80694A06f");
        require(
            vm.envAddress("ECDSA_DKIM") ==
                0x6600f69ba900BFD830bE1a8985ED59A80694A06f,
            "ECDSA_DKIM address mismatch"
        );
        require(
            vm.envAddress("VERIFIER") ==
                0x38323919eFb82A1f1a04D863BbBe12925cb93f2D,
            "VERIFIER address mismatch"
        );
        require(
            vm.envAddress("EMAIL_AUTH_IMPL") ==
                0x4393aB187b8B509d153681383a8aB26593BfA8d6,
            "EMAIL_AUTH_IMPL address mismatch"
        );
        require(
            vm.envAddress("RECOVERY_CONTROLLER") ==
                0x064c9B191E626618b787e77630995bDcEbAD69F6,
            "RECOVERY_CONTROLLER address mismatch"
        );
        require(
            vm.envAddress("SIMPLE_WALLET") ==
                0x300f752d60986Dd7b7b41795e46b3326D8127dCb,
            "SIMPLE_WALLET address mismatch"
        );
    }
}
