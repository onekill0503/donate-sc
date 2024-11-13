// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/Donate.sol";
import {Vault} from "../src/Vault.sol";
import {MockUSDE} from "../src/MockUSDE.sol";
import {MockSUSDE} from "../src/MockSUSDE.sol";

contract DonateTest is Test {
    Donate public donate;
    MockUSDE public MUSDE;
    MockSUSDE public MSUSDE;
    Vault public vault;
    address public usde = makeAddr("USDE");
    address public susde = makeAddr("sUSDE");

    address public platform = makeAddr("platform");
    address public owner = address(this);

    // Content Creator
    address public alex = makeAddr("alex");

    // User
    address public asep = makeAddr("asep");
    address public budi = makeAddr("budi");

    function setUp() public {}

    function test_Donate() public {}
}
