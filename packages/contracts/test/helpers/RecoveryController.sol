// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {EmailAccountRecovery} from "../../src/EmailAccountRecovery.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {SimpleWallet} from "./SimpleWallet.sol";
import "forge-std/console.sol";

interface CbSmartWallet {
    function addOwnerPublicKey(bytes32 x, bytes32 y) external;
}

contract RecoveryController is OwnableUpgradeable, EmailAccountRecovery {
    enum GuardianStatus {
        NONE,
        REQUESTED,
        ACCEPTED
    }
    uint public constant DEFAULT_TIMELOCK_PERIOD = 0 days;

    mapping(address => bool) public isActivatedOfAccount;
    mapping(address => bool) public isRecovering;
    mapping(address => bytes) public newSignerCandidateOfAccount;
    // How is an email address tied to an address?
    mapping(address => GuardianStatus) public guardians;
    mapping(address => uint) public timelockPeriodOfAccount;
    mapping(address => uint) public currentTimelockOfAccount;

    // modifier onlyNotRecoveringOwner() {
    //     require(msg.sender == owner(), "only owner");
    //     require(!isRecovering, "recovery in progress");
    //     _;
    // }

    constructor() {}

    function initialize(
        address _initialOwner,
        address _verifier,
        address _dkim,
        address _emailAuthImplementation
    ) public initializer {
        __Ownable_init(_initialOwner);
        verifierAddr = _verifier;
        dkimAddr = _dkim;
        emailAuthImplementationAddr = _emailAuthImplementation;
    }

    function isActivated(
        address recoveredAccount
    ) public view override returns (bool) {
        return isActivatedOfAccount[recoveredAccount];
    }

    function acceptanceSubjectTemplates()
        public
        pure
        override
        returns (string[][] memory)
    {
        string[][] memory templates = new string[][](1);
        templates[0] = new string[](5);
        templates[0][0] = "Accept";
        templates[0][1] = "guardian";
        templates[0][2] = "request";
        templates[0][3] = "for";
        templates[0][4] = "{ethAddr}";
        return templates;
    }

    function recoverySubjectTemplates()
        public
        pure
        override
        returns (string[][] memory)
    {
        string[][] memory templates = new string[][](1);
        templates[0] = new string[](8);
        templates[0][0] = "Set";
        templates[0][1] = "the";
        templates[0][2] = "new";
        templates[0][3] = "signer";
        templates[0][4] = "of";
        templates[0][5] = "{ethAddr}";
        templates[0][6] = "to";
        templates[0][7] = "{string}";
        return templates;
    }

    function extractRecoveredAccountFromAcceptanceSubject(
        bytes[] memory subjectParams,
        uint templateIdx
    ) public pure override returns (address) {
        require(templateIdx == 0, "invalid template index");
        require(subjectParams.length == 1, "invalid subject params");
        return abi.decode(subjectParams[0], (address));
    }

    function extractRecoveredAccountFromRecoverySubject(
        bytes[] memory subjectParams,
        uint templateIdx
    ) public pure override returns (address) {
        require(templateIdx == 0, "invalid template index");
        require(subjectParams.length == 2, "invalid subject params");
        return abi.decode(subjectParams[0], (address));
    }

    function requestGuardian(address guardian) public {
        address account = msg.sender;
        require(!isRecovering[account], "recovery in progress");
        require(guardian != address(0), "invalid guardian");
        require(
            guardians[guardian] == GuardianStatus.NONE,
            "guardian status must be NONE"
        );
        if (!isActivatedOfAccount[account]) {
            isActivatedOfAccount[account] = true;
        }
        guardians[guardian] = GuardianStatus.REQUESTED;
    }

    function configureTimelockPeriod(uint period) public {
        timelockPeriodOfAccount[msg.sender] = period;
    }

    function acceptGuardian(
        address guardian,
        uint templateIdx,
        bytes[] memory subjectParams,
        bytes32
    ) internal override {
        address account = abi.decode(subjectParams[0], (address));
        require(!isRecovering[account], "recovery in progress");
        require(guardian != address(0), "invalid guardian");

        require(
            guardians[guardian] == GuardianStatus.REQUESTED,
            "guardian status must be REQUESTED"
        );
        require(templateIdx == 0, "invalid template index");
        require(subjectParams.length == 1, "invalid subject params");
        guardians[guardian] = GuardianStatus.ACCEPTED;
    }

    function processRecovery(
        address guardian,
        uint templateIdx,
        bytes[] memory subjectParams,
        bytes32
    ) internal override {
        address account = abi.decode(subjectParams[0], (address));
        require(!isRecovering[account], "recovery in progress");
        require(guardian != address(0), "invalid guardian");
        require(
            guardians[guardian] == GuardianStatus.ACCEPTED,
            "guardian status must be ACCEPTED"
        );
        require(templateIdx == 0, "invalid template index");
        require(subjectParams.length == 2, "invalid subject params");
        // subjectParams[1] will be in the form 0xAAAAAAAA...
        bytes memory newSignerInEmail = abi.decode(subjectParams[1], (bytes));
        isRecovering[account] = true;
        // TODO: how will we represent x,y public key in email
        newSignerCandidateOfAccount[account] = newSignerInEmail;
        currentTimelockOfAccount[account] =
            block.timestamp +
            timelockPeriodOfAccount[account];
    }

    function rejectRecovery() public {
        address account = msg.sender;
        require(isRecovering[account], "recovery not in progress");
        require(
            currentTimelockOfAccount[account] > block.timestamp,
            "timelock expired"
        );
        isRecovering[account] = false;
        newSignerCandidateOfAccount[account] = bytes("");
        currentTimelockOfAccount[account] = 0;
    }

    function completeRecovery(address account, bytes memory) public override {
        require(account != address(0), "invalid account");
        require(isRecovering[account], "recovery not in progress");
        require(
            currentTimelockOfAccount[account] <= block.timestamp,
            "timelock not expired"
        );
        bytes memory newSigner = newSignerCandidateOfAccount[account];
        (bytes32 x, bytes32 y) = abi.decode(newSigner, (bytes32, bytes32));
        isRecovering[account] = false;
        currentTimelockOfAccount[account] = 0;
        newSignerCandidateOfAccount[account] = bytes("");
        CbSmartWallet(payable(account)).addOwnerPublicKey(x, y);
    }
}
