// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../../../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract ECDSAOwnedDKIMRegistryTest_changeSigner is Test {
    ECDSAOwnedDKIMRegistry dkim;

    function setUp() public {
        address signer = vm.addr(1);
        ECDSAOwnedDKIMRegistry dkimImpl = new ECDSAOwnedDKIMRegistry();
        ERC1967Proxy dkimProxy = new ERC1967Proxy(
            address(dkimImpl),
            abi.encodeCall(dkimImpl.initialize, (msg.sender, signer))
        );
        dkim = ECDSAOwnedDKIMRegistry(address(dkimProxy));
    }

    function test_ChangeSigner() public {
        address owner = dkim.owner();
        address newSigner = vm.addr(2);

        vm.startPrank(owner);
        dkim.changeSigner(newSigner);
        vm.stopPrank();

        assertEq(dkim.signer(), newSigner, "Signer was not changed correctly");
    }

    function test_Revert_IfNewSignerIsZeroAddress() public {
        address owner = dkim.owner();
        vm.startPrank(owner);

        vm.expectRevert("Invalid signer");
        dkim.changeSigner(address(0));
    }

    function test_Revert_IfNewSignerIsSame() public {
        address owner = dkim.owner();
        address currentSigner = dkim.signer();

        vm.startPrank(owner);
        vm.expectRevert("Same signer");
        dkim.changeSigner(currentSigner);
    }
}
