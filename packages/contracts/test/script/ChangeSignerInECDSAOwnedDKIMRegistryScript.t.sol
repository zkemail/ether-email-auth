// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployRecoveryController.s.sol";
import {ChangeSigner} from "../../script/ChangeSignerInECDSAOwnedDKIMRegistry.s.sol";
import {ECDSAOwnedDKIMRegistry} from "../../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {StructHelper} from "../helpers/StructHelper.sol";

contract ChangeSignerInECDSAOwnedDKIMRegistryScriptTest is StructHelper {
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
        vm.setEnv("NEW_SIGNER", "0xa1bec2dd161d6bbcc91ec32aa44d9333e2a864c0");
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
        deploy.deployECDSAOwnedDKIMRegistry(
            vm.addr(vm.envUint("PRIVATE_KEY")),
            vm.envAddress("DKIM_SIGNER")
        );
        vm.setEnv("ECDSA_DKIM", "0x6600f69ba900BFD830bE1a8985ED59A80694A06f");
        ChangeSigner changeSigner = new ChangeSigner();
        changeSigner.run();
        address ecdsaDkimAddr = vm.envAddress("ECDSA_DKIM");
        ECDSAOwnedDKIMRegistry ecdsaDkim = ECDSAOwnedDKIMRegistry(
            ecdsaDkimAddr
        );
        assertEq(ecdsaDkim.signer(), vm.envAddress("NEW_SIGNER"));
    }
}
