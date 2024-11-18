// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/Donate.sol";
import { SUSDE } from "../src/SUSDE.sol";
import { USDE } from "../src/USDE.sol";
import "../src/interfaces/IDonate.sol";
import "../src/interfaces/ISUSDE.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract DonateTest is Test {
    Donate public donate;
    USDE public usde;
    SUSDE public susde;

    address public creator = makeAddr("creator");
    address public platform = makeAddr("platform");
    address public owner = address(this);

    address public userX = 0x88a1493366D48225fc3cEFbdae9eBb23E323Ade3;
    address public userY = 0x1c00881a4b935D58E769e7c85F5924B8175D1526;

    function setUp() public {
        vm.startBroadcast();
        usde = USDE(0x6712008CCD96751d586FdBa0DEf5495E0E22D904);
        susde = SUSDE(0x53DaB165b879542E9aDFC41c6474A9d797B9b042);
        donate = Donate(0x03F7F064E6ceD8e154e3FdAAF92DcCC4e818E97B);
        vm.stopBroadcast();
    }

    function run() public {
        vm.startBroadcast();

        usde.approve(address(donate), 50 ether);

        donate.donate(50 ether, creator, address(usde));

        // vm.startPrank(userX);
        // uint256 _yield = donate.getYield(address(userX));
        // console.log("Yield: ", _yield);
        vm.stopBroadcast();
    }
}
