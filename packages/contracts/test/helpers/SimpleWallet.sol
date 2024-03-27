// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {EmailAccountRecovery} from "../../src/EmailAccountRecovery.sol";

contract SimpleWallet is OwnableUpgradeable, EmailAccountRecovery {
    enum GuardianStatus {
        NONE,
        REQUESTED,
        ACCEPTED
    }
    uint public constant TIMELOCK_PERIOD = 3 days;

    bool isRecovering;
    address newSignerCandidate;
    mapping(address => GuardianStatus) public guardians;
    uint timelock;

    modifier onlyNotRecoveringOwner() {
        require(msg.sender == owner(), "only owner");
        require(!isRecovering, "recovery in progress");
        _;
    }

    /// @notice Fallback function to receive ETH
    fallback() external payable {
        require(!isRecovering, "recovery in progress");
    }

    /// @notice Function to receive ETH
    receive() external payable {
        require(!isRecovering, "recovery in progress");
    }

    constructor() {}

    function initialize(
        address _verifier,
        address _dkim,
        address _emailAuthImplementation
    ) public initializer {
        __Ownable_init();
        isRecovering = false;
        verifierAddr = _verifier;
        dkimAddr = _dkim;
        emailAuthImplementationAddr = _emailAuthImplementation;
    }

    function transfer(
        address to,
        uint256 amount
    ) public onlyNotRecoveringOwner {
        require(address(this).balance >= amount, "insufficient balance");
        payable(to).transfer(amount);
    }

    function withdraw(uint256 amount) public onlyNotRecoveringOwner {
        transfer(msg.sender, amount);
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
        templates[0][7] = "{ethAddr}";
        return templates;
    }

    function requestGuardian(address guardian) public onlyNotRecoveringOwner {
        require(guardian != address(0), "invalid guardian");
        require(
            guardians[guardian] == GuardianStatus.NONE,
            "invalid guardian status"
        );
        guardians[guardian] = GuardianStatus.REQUESTED;
    }

    function acceptGuardian(
        address guardian,
        uint templateIdx,
        bytes[] memory subjectParams,
        bytes32
    ) internal override onlyNotRecoveringOwner {
        require(guardian != address(0), "invalid guardian");
        require(
            guardians[guardian] == GuardianStatus.REQUESTED,
            "invalid guardian status"
        );
        require(templateIdx == 0, "invalid template index");
        require(subjectParams.length == 1, "invalid subject params");
        address guardianInEmail = abi.decode(subjectParams[0], (address));
        require(guardianInEmail == guardian, "invalid guardian in email");
        guardians[guardian] = GuardianStatus.ACCEPTED;
    }

    function processRecovery(
        address guardian,
        uint templateIdx,
        bytes[] memory subjectParams,
        bytes32
    ) internal override onlyNotRecoveringOwner {
        require(guardian != address(0), "invalid guardian");
        require(
            guardians[guardian] == GuardianStatus.ACCEPTED,
            "invalid guardian status"
        );
        require(templateIdx == 0, "invalid template index");
        require(subjectParams.length == 2, "invalid subject params");
        address walletAddrInEmail = abi.decode(subjectParams[0], (address));
        address newSignerInEmail = abi.decode(subjectParams[1], (address));
        require(
            walletAddrInEmail == address(this),
            "invalid guardian in email"
        );
        require(newSignerInEmail != address(0), "invalid new signer");
        isRecovering = true;
        newSignerCandidate = newSignerInEmail;
        timelock = block.timestamp + TIMELOCK_PERIOD;
    }

    function rejectRecovery() public onlyOwner {
        require(isRecovering, "recovery not in progress");
        require(timelock > block.timestamp, "timelock expired");
        isRecovering = false;
        newSignerCandidate = address(0);
        timelock = 0;
    }

    function completeRecovery() public override {
        require(isRecovering, "recovery not in progress");
        require(timelock <= block.timestamp, "timelock not expired");
        isRecovering = false;
        timelock = 0;
        _transferOwnership(newSignerCandidate);
        newSignerCandidate = address(0);
    }
}
