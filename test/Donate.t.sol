// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/Donate.sol";
import "../src/interfaces/IDonate.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/interfaces/ISUSDE.sol";

contract DonateTest is Test {
    IDonate donate;
    ISUSDE susde;
    function setUp() public {
        donate = IDonate(address(0xc535711468ED0c21e4B6E0033C4852a1A0cd5848));
        susde = ISUSDE(address(0x9D39A5DE30e57443BfF2A8307A4256c8797A3497));
    }

    function test_Donate() public {
    // Set up the pranked address
    address prankedAddress = address(0x88a1493366D48225fc3cEFbdae9eBb23E323Ade3);

    // Begin the prank for the pranked address
    vm.startPrank(prankedAddress);

    // Interact with the IERC20 token
    IERC20 usde = IERC20(0x4c9EDD5852cd905f086C759E8383e09bff1E68B3);

    // Log information for debugging
    console.log("pranked address: ", prankedAddress);
    console.log("usde balance: ", usde.balanceOf(prankedAddress));

    // Approve tokens from the pranked address
    usde.approve(address(susde), 50e18);
    usde.transfer(0x4e7f666cd88254377a2B3B87d301a38Ca440DA9F , 50e18);
    // Perform the donation
    donate.donate(50e18, address(0x4e7f666cd88254377a2B3B87d301a38Ca440DA9F), address(usde));

    // End the prank
    vm.stopPrank();
    }
}
