// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/Donate.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract DonateTest is Test {
    Donate public donate;
    ERC20 public usde;
    ERC4626 public susde;
    address usdeAddress = 0x4c9EDD5852cd905f086C759E8383e09bff1E68B3;
    address susdeAddress = 0x9D39A5DE30e57443BfF2A8307A4256c8797A3497;

    address public creator = makeAddr("creator");
    address public platform = makeAddr("platform");
    address public owner = address(this);

    address public userX = 0x88a1493366D48225fc3cEFbdae9eBb23E323Ade3;
    address public userY = 0x1c00881a4b935D58E769e7c85F5924B8175D1526;

    function setUp() public {
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/psMgMPfXjYv8RHvhTKDDcAOv6HV0pdIA", 21178781);
        usde = ERC20(usdeAddress);
        susde = ERC4626(susdeAddress);

        donate = new Donate(platform, susdeAddress);
        donate.addAllowedDonationToken(usdeAddress);
    }

    function test_Donate() public {
        uint256 usdeBalanceX = usde.balanceOf(userX);
        uint256 usdeBalanceY = usde.balanceOf(userY);

        assertEq(usdeBalanceX, 200000050000000000000000000);
        assertEq(usdeBalanceY, 19940900000000668011689410);

        vm.startPrank(userX);
        usde.approve(address(donate), 50 ether);
        uint256 allowance = usde.allowance(userX, address(donate));
        assertEq(allowance, 50 ether, "Allowance not set correctly");

        donate.donate(50 ether, creator, usdeAddress);

        uint256 usdeBalanceXAfter = usde.balanceOf(userX);
        assertEq(usdeBalanceXAfter, usdeBalanceX - 50 ether, "Balance not deducted correctly");
        vm.stopPrank();

        vm.startPrank(userX);
        uint256 _yield = donate.getYield(address(userX));
        console.log("Yield: ", _yield);
    }
}
