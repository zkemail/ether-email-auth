// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";

contract EmailAuthTest is Test {
    EmailAuth emailAuth;
    Verifier verifier;
    ECDSAOwnedDKIMRegistry dkim;

    bytes32 accountSalt;
    uint templateId;
    string[] subjectTemplate;
    string[] newSubjectTemplate;

    function setUp() public {
        dkim = new ECDSAOwnedDKIMRegistry(msg.sender);
        verifier = new Verifier();

        // Create EmailAuth
        emailAuth = new EmailAuth();
        emailAuth.updateVerifier(address(verifier));
        emailAuth.updateDKIMRegistry(address(dkim));

        uint templateIdx = 1;
        templateId = uint256(keccak256(abi.encodePacked("TEST", templateIdx)));
        subjectTemplate = ["Send", "{decimals}", "ETH", "to", "{ethAddr}"];
        newSubjectTemplate = ["Send", "{decimals}", "USDC", "to", "{ethAddr}"];
    }

    function testDkimRegistryAddr() public view {
        address dkimAddr = emailAuth.dkimRegistryAddr();
        assertEq(dkimAddr, address(dkim));
    }
    
    function testVerifierAddr() public view {
        address verifierAddr = emailAuth.verifierAddr();
        assertEq(verifierAddr, address(verifier));
    }

    function testUpdateDKIMRegistry() public {
        ECDSAOwnedDKIMRegistry newDKIM = new ECDSAOwnedDKIMRegistry(msg.sender);
        emailAuth.updateDKIMRegistry(address(newDKIM));
        assertEq(emailAuth.dkimRegistryAddr(), address(newDKIM));
    }
    
    function testUpdateVerifier() public {
        Verifier newVerifier = new Verifier();
        emailAuth.updateVerifier(address(newVerifier));
        assertEq(emailAuth.verifierAddr(), address(newVerifier));
    }

    function testInsertSubjectTemplate() public {        
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
    }

    function testUpdateSubjectTemplate() public {
        this.testInsertSubjectTemplate();
        emailAuth.updateSubjectTemplate(templateId, newSubjectTemplate);
    }

    function testDeleteSubjectTemplate() public {
        this.testInsertSubjectTemplate();
        emailAuth.deleteSubjectTemplate(templateId);
    }

    function testComputeMsgHash() public view {
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(1);
        subjectParams[1] = abi.encode(vm.addr(1));
        bytes32 msgHash = emailAuth.computeMsgHash(accountSalt, true, templateId, subjectParams);
        assertEq(msgHash, 0x34cf6244c520f5e41b21f35403a92f8b2005bf696a72aeb0c0f3f77d95fa0a0e);
    }

    // function testAuthEmail() public {
    //     this.testInsertSubjectTemplate();
    //     bytes[] memory subjectParams = new bytes[](2);
    //     subjectParams[0] = abi.encode(1);
    //     subjectParams[1] = abi.encode(vm.addr(1));
    //     emailAuth.authEmail(accountSalt, true, templateId, subjectParams, signature);
    // }
}

