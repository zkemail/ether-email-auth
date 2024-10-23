// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/utils/ForwardDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./helpers/StructHelper.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAuthTest is StructHelper {
    function setUp() public override {
        super.setUp();

        vm.startPrank(deployer);
        emailAuth.initialize(deployer, accountSalt, deployer);
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.VerifierUpdated(address(verifier));
        emailAuth.updateVerifier(address(verifier));
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.DKIMRegistryUpdated(address(dkim));
        emailAuth.updateDKIMRegistry(address(dkim));
        vm.stopPrank();
    }

    function testDkimRegistryAddr() public view {
        address dkimAddr = emailAuth.dkimRegistryAddr();
        assertEq(dkimAddr, address(dkim));
    }

    function testVerifierAddr() public view {
        address verifierAddr = emailAuth.verifierAddr();
        assertEq(verifierAddr, address(verifier));
    }

    function testUpdateDKIMRegistryToECDSA() public {
        assertEq(emailAuth.dkimRegistryAddr(), address(dkim));

        vm.startPrank(deployer);
        ECDSAOwnedDKIMRegistry newDKIM;
        {
            ECDSAOwnedDKIMRegistry dkimImpl = new ECDSAOwnedDKIMRegistry();
            ERC1967Proxy dkimProxy = new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(dkimImpl.initialize, (msg.sender, msg.sender))
            );
            newDKIM = ECDSAOwnedDKIMRegistry(address(dkimProxy));
        }
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.DKIMRegistryUpdated(address(newDKIM));
        emailAuth.updateDKIMRegistry(address(newDKIM));
        vm.stopPrank();

        assertEq(emailAuth.dkimRegistryAddr(), address(newDKIM));
    }

    function testUpdateDKIMRegistryToForward() public {
        assertEq(emailAuth.dkimRegistryAddr(), address(dkim));

        vm.startPrank(deployer);
        ECDSAOwnedDKIMRegistry dummyDKIM = new ECDSAOwnedDKIMRegistry();
        ForwardDKIMRegistry newDKIM;
        {
            ForwardDKIMRegistry dkimImpl = new ForwardDKIMRegistry();
            ERC1967Proxy dkimProxy = new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(
                    dkimImpl.initialize,
                    (msg.sender, address(dummyDKIM))
                )
            );
            newDKIM = ForwardDKIMRegistry(address(dkimProxy));
        }
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.DKIMRegistryUpdated(address(newDKIM));
        emailAuth.updateDKIMRegistry(address(newDKIM));
        vm.stopPrank();

        assertEq(emailAuth.dkimRegistryAddr(), address(newDKIM));
    }

    function testExpectRevertUpdateDKIMRegistryInvalidDkimRegistryAddress()
        public
    {
        assertEq(emailAuth.dkimRegistryAddr(), address(dkim));

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid dkim registry address"));
        emailAuth.updateDKIMRegistry(address(0));
        vm.stopPrank();
    }

    function testUpdateVerifier() public {
        assertEq(emailAuth.verifierAddr(), address(verifier));

        vm.startPrank(deployer);
        Verifier newVerifier = new Verifier();
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.VerifierUpdated(address(newVerifier));
        emailAuth.updateVerifier(address(newVerifier));
        vm.stopPrank();

        assertEq(emailAuth.verifierAddr(), address(newVerifier));
    }

    function testExpectRevertUpdateVerifierInvalidVerifierAddress() public {
        assertEq(emailAuth.verifierAddr(), address(verifier));

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid verifier address"));
        emailAuth.updateVerifier(address(0));
        vm.stopPrank();
    }

    function testGetCommandTemplate() public {
        vm.startPrank(deployer);
        emailAuth.insertCommandTemplate(templateId, commandTemplate);
        vm.stopPrank();
        string[] memory result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, commandTemplate);
    }

    function testExpectRevertGetCommandTemplateTemplateIdNotExists() public {
        vm.expectRevert(bytes("template id not exists"));
        emailAuth.getCommandTemplate(templateId);
    }

    function testInsertCommandTemplate() public {
        vm.startPrank(deployer);
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.CommandTemplateInserted(templateId);
        _testInsertCommandTemplate();
        vm.stopPrank();
    }

    function _testInsertCommandTemplate() private {
        emailAuth.insertCommandTemplate(templateId, commandTemplate);
        string[] memory result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, commandTemplate);
    }

    function testExpectRevertInsertCommandTemplateCommandTemplateIsEmpty()
        public
    {
        vm.startPrank(deployer);
        string[] memory emptyCommandTemplate = new string[](0);
        vm.expectRevert(bytes("command template is empty"));
        emailAuth.insertCommandTemplate(templateId, emptyCommandTemplate);
        vm.stopPrank();
    }

    function testExpectRevertInsertCommandTemplateTemplateIdAlreadyExists()
        public
    {
        vm.startPrank(deployer);
        emailAuth.insertCommandTemplate(templateId, commandTemplate);
        string[] memory result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, commandTemplate);

        vm.expectRevert(bytes("template id already exists"));
        emailAuth.insertCommandTemplate(templateId, commandTemplate);
        vm.stopPrank();
    }

    function testUpdateCommandTemplate() public {
        vm.expectRevert(bytes("template id not exists"));
        string[] memory result = emailAuth.getCommandTemplate(templateId);

        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        vm.stopPrank();

        result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, commandTemplate);

        vm.startPrank(deployer);
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.CommandTemplateUpdated(templateId);
        emailAuth.updateCommandTemplate(templateId, newCommandTemplate);
        vm.stopPrank();

        result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, newCommandTemplate);
    }

    function testExpectRevertUpdateCommandTemplateCallerIsNotTheModule()
        public
    {
        vm.expectRevert("only controller");
        emailAuth.updateCommandTemplate(templateId, commandTemplate);
    }

    function testExpectRevertUpdateCommandTemplateCommandTemplateIsEmpty()
        public
    {
        vm.startPrank(deployer);

        string[] memory emptyCommandTemplate = new string[](0);
        vm.expectRevert(bytes("command template is empty"));
        emailAuth.updateCommandTemplate(templateId, emptyCommandTemplate);

        vm.stopPrank();
    }

    function testExpectRevertUpdateCommandTemplateTemplateIdNotExists() public {
        vm.startPrank(deployer);

        vm.expectRevert(bytes("template id not exists"));
        emailAuth.updateCommandTemplate(templateId, commandTemplate);

        vm.stopPrank();
    }

    function testDeleteCommandTemplate() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        vm.stopPrank();

        string[] memory result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, commandTemplate);

        vm.startPrank(deployer);
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.CommandTemplateDeleted(templateId);
        emailAuth.deleteCommandTemplate(templateId);
        vm.stopPrank();

        vm.expectRevert(bytes("template id not exists"));
        emailAuth.getCommandTemplate(templateId);
    }

    function testExpectRevertDeleteCommandTemplateCallerIsNotTheModule()
        public
    {
        vm.expectRevert("only controller");
        emailAuth.deleteCommandTemplate(templateId);
    }

    function testExpectRevertDeleteCommandTemplateTemplateIdNotExists() public {
        vm.startPrank(deployer);
        vm.expectRevert(bytes("template id not exists"));
        emailAuth.deleteCommandTemplate(templateId);
        vm.stopPrank();
    }

    function testAuthEmail() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        vm.expectEmit(true, true, true, true);
        emit EmailAuth.EmailAuthed(
            emailAuthMsg.proof.emailNullifier,
            emailAuthMsg.proof.accountSalt,
            emailAuthMsg.proof.isCodeExist,
            emailAuthMsg.templateId
        );
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            true
        );
        assertEq(emailAuth.lastTimestamp(), emailAuthMsg.proof.timestamp);
    }

    function testExpectRevertAuthEmailCallerIsNotTheModule() public {
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.expectRevert("only controller");
        emailAuth.authEmail(emailAuthMsg);
    }

    function testExpectRevertAuthEmailTemplateIdNotExists() public {
        vm.startPrank(deployer);
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("template id not exists"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidDkimPublicKeyHash() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        emailAuthMsg.proof.domainName = "invalid.com";
        vm.expectRevert(bytes("invalid dkim public key hash"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailEmailNullifierAlreadyUsed() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        emailAuth.authEmail(emailAuthMsg);
        vm.expectRevert(bytes("email nullifier already used"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidAccountSalt() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        emailAuthMsg.proof.accountSalt = bytes32(uint256(1234));
        vm.expectRevert(bytes("invalid account salt"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidTimestamp() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            true
        );
        assertEq(emailAuth.lastTimestamp(), emailAuthMsg.proof.timestamp);

        vm.startPrank(deployer);
        emailAuthMsg.proof.emailNullifier = 0x0;
        emailAuthMsg.proof.timestamp = 1694989812;
        vm.expectRevert(bytes("invalid timestamp"));
        emailAuth.authEmail(emailAuthMsg);

        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidCommand() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        emailAuthMsg.commandParams[0] = abi.encode(2 ether);
        vm.expectRevert(bytes("invalid command"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidEmailProof() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        vm.mockCall(
            address(verifier),
            abi.encodeWithSelector(
                Verifier.verifyEmailProof.selector,
                emailAuthMsg.proof
            ),
            abi.encode(false)
        );
        vm.expectRevert(bytes("invalid email proof"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidMaskedCommandLength() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        // Set masked command length to 606, which should be 605 or less defined in the verifier.
        emailAuthMsg.proof.maskedCommand = string(new bytes(606));

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid masked command length"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidSizeOfTheSkippedCommandPrefix()
        public
    {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        // Set skipped command prefix length to 605, it should be less than 605.
        emailAuthMsg.skippedCommandPrefix = 605;

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid size of the skipped command prefix"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testSetTimestampCheckEnabled() public {
        vm.startPrank(deployer);

        assertTrue(emailAuth.timestampCheckEnabled());
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.TimestampCheckEnabled(false);
        emailAuth.setTimestampCheckEnabled(false);
        assertFalse(emailAuth.timestampCheckEnabled());

        vm.stopPrank();
    }

    function testExpectRevertSetTimestampCheckEnabled() public {
        vm.expectRevert("only controller");
        emailAuth.setTimestampCheckEnabled(false);
    }

    function testUpgradeEmailAuth() public {
        vm.startPrank(deployer);

        // Deploy new implementation
        EmailAuth newImplementation = new EmailAuth();

        // Execute upgrade using proxy
        // Upgrade implementation through proxy contract
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(emailAuth),
            abi.encodeCall(
                emailAuth.initialize,
                (deployer, accountSalt, deployer)
            )
        );
        EmailAuth emailAuthProxy = EmailAuth(payable(proxy));
        bytes32 beforeAccountSalt = emailAuthProxy.accountSalt();

        // Upgrade to new implementation through proxy
        emailAuthProxy.upgradeToAndCall(
            address(newImplementation),
            new bytes(0)
        );

        bytes32 afterAccountSalt = emailAuthProxy.accountSalt();

        // Verify the upgrade
        assertEq(beforeAccountSalt, afterAccountSalt);

        vm.stopPrank();
    }
}
