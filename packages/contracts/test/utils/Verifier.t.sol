// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../../src/utils/Verifier.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract VerifierTest is Test {
    Verifier public verifier;
    address public deployer;

    function setUp() public {
        deployer = address(this);
        verifier = new Verifier();
    }

    function testUpgradeVerifier() public {
        // Deploy new implementation
        Verifier newImplementation = new Verifier();

        // Execute upgrade using proxy
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(verifier),
            abi.encodeCall(
                verifier.initialize,
                (deployer, address(0)) // Assuming a dummy address for groth16Verifier
            )
        );
        Verifier verifierProxy = Verifier(address(proxy));

        // Store initial values for comparison
        uint256 initialDomainFields = verifierProxy.DOMAIN_FIELDS();
        uint256 initialDomainBytes = verifierProxy.DOMAIN_BYTES();

        // Upgrade to new implementation through proxy
        verifierProxy.upgradeToAndCall(
            address(newImplementation),
            new bytes(0)
        );

        // Verify the upgrade
        assertEq(verifierProxy.DOMAIN_FIELDS(), initialDomainFields);
        assertEq(verifierProxy.DOMAIN_BYTES(), initialDomainBytes);
    }
}
