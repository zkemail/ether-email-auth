// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../../src/EmailAuth.sol";
import "../../src/utils/Verifier.sol";
import "../../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "./SimpleWallet.sol";
import "./RecoveryModule.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeploymentHelper is Test {
    using ECDSA for *;

    EmailAuth emailAuth;
    Verifier verifier;
    ECDSAOwnedDKIMRegistry dkim;
    RecoveryModule recoveryModule;
    SimpleWallet simpleWallet;

    address deployer = vm.addr(1);
    address receiver = vm.addr(2);
    address guardian;
    address newSigner = vm.addr(4);
    address someRelayer = vm.addr(5);

    bytes32 accountSalt;
    uint templateId;
    string[] subjectTemplate;
    string[] newSubjectTemplate;
    bytes mockProof = abi.encodePacked(bytes1(0x01));

    string selector = "12345";
    string domainName = "gmail.com";
    bytes32 publicKeyHash =
        0x0ea9c777dc7110e5a9e89b13f0cfc540e3845ba120b2b6dc24024d61488d4788;
    bytes32 emailNullifier =
        0x00a83fce3d4b1c9ef0f600644c1ecc6c8115b57b1596e0e3295e2c5105fbfd8a;

    function setUp() public virtual {
        // For zkSync computeEmailAuthAddress uses L2ContractHelper.computeCreate2Address
        // The gardian address should be different from other EVM chains
        if (block.chainid == 300) {
            guardian = address(0x4110796d50E5a4f51E626B00c38af39d236Ec8b9);
        } else {
            guardian = address(0xa0cD5E8f1663E9218e3Adb2544377e2f663c2999);
        }

        vm.startPrank(deployer);
        address signer = deployer;

        // Create DKIM registry
        dkim = new ECDSAOwnedDKIMRegistry(signer);
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(
            bytes(signedMsg)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(
            selector,
            domainName,
            publicKeyHash,
            signature
        );

        // Create Verifier
        verifier = new Verifier();
        accountSalt = 0x2c3abbf3d1171bfefee99c13bf9c47f1e8447576afd89096652a34f27b297971;

        // Create EmailAuth
        EmailAuth emailAuthImpl = new EmailAuth();
        emailAuth = emailAuthImpl;

        uint templateIdx = 0;
        templateId = uint256(keccak256(abi.encodePacked("TEST", templateIdx)));
        subjectTemplate = ["Send", "{decimals}", "ETH", "to", "{ethAddr}"];
        newSubjectTemplate = ["Send", "{decimals}", "USDC", "to", "{ethAddr}"];

        // Create RecoveryModule as EmailAccountRecovery implementation
        RecoveryModule recoveryModuleImpl = new RecoveryModule();
        ERC1967Proxy recoveryModuleProxy = new ERC1967Proxy(
            address(recoveryModuleImpl),
            abi.encodeCall(
                recoveryModuleImpl.initialize,
                (
                    signer,
                    address(verifier),
                    address(dkim),
                    address(emailAuthImpl)
                )
            )
        );
        recoveryModule = RecoveryModule(payable(address(recoveryModuleProxy)));

        // Create SimpleWallet
        SimpleWallet simpleWalletImpl = new SimpleWallet();
        ERC1967Proxy simpleWalletProxy = new ERC1967Proxy(
            address(simpleWalletImpl),
            abi.encodeCall(
                simpleWalletImpl.initialize,
                (signer, address(recoveryModule))
            )
        );
        simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
        vm.deal(address(simpleWallet), 1 ether);
        vm.stopPrank();
    }
}
