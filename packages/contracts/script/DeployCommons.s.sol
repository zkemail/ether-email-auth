// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/EmailAuth.sol";


contract Deploy is Script {
    using ECDSA for *;

    ECDSAOwnedDKIMRegistry dkim;
    Verifier verifier;
    EmailAuth emailAuthImpl;
    SimpleWallet simpleWalletImpl;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy DKIM registry
        ECDSAOwnedDKIMRegistry dkim = new ECDSAOwnedDKIMRegistry(
            vm.addr(deployerPrivateKey)
        );
        string memory selector = vm.envString("SELECTOR");
        string memory domainName = vm.envString("DOMAIN_NAME");
        bytes32 publicKeyHash = vm.envBytes32("PUBLIC_KEY_HASH");

        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = bytes(signedMsg).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(deployerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(
            selector,
            domainName,
            publicKeyHash,
            signature
        );

        // Create Verifier
        Verifier verifier = new Verifier();
        bytes32 accountSalt = vm.envBytes32("ACCOUNT_SALT");

        // Create EmailAuth
        EmailAuth emailAuth = new EmailAuth(accountSalt);
        emailAuth.updateVerifier(address(verifier));
        emailAuth.updateDKIMRegistry(address(dkim));

        // Insert first subject template
        uint256 templateId = 1;
        string[] memory subjectTemplate = new string[](5);
        subjectTemplate[0] = "Send";
        subjectTemplate[1] = "{decimals}";
        subjectTemplate[2] = "ETH";
        subjectTemplate[3] = "to";
        subjectTemplate[4] = "{string}";
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);

        vm.stopBroadcast();
    }
}
