pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../../src/EmailAuth.sol";
import "../../src/utils/Verifier.sol";
import "../../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeploymentHelper is Test {
    using ECDSA for *;

    EmailAuth emailAuth;
    Verifier verifier;
    ECDSAOwnedDKIMRegistry dkim;

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
        address signer = vm.addr(1);

        // Create DKIM registry
        dkim = new ECDSAOwnedDKIMRegistry(signer);
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = bytes(signedMsg).toEthSignedMessageHash();
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
        ERC1967Proxy emailAuthProxy = new ERC1967Proxy(address(emailAuthImpl), abi.encodeCall(emailAuthImpl.initialize, 
                accountSalt
            ));
        emailAuth = EmailAuth(payable(address(emailAuthProxy)));
        emailAuth.updateVerifier(address(verifier));
        emailAuth.updateDKIMRegistry(address(dkim));

        

        uint templateIdx = 1;
        templateId = uint256(keccak256(abi.encodePacked("TEST", templateIdx)));
        subjectTemplate = ["Send", "{decimals}", "ETH", "to", "{ethAddr}"];
        newSubjectTemplate = ["Send", "{decimals}", "USDC", "to", "{ethAddr}"];
    }
}