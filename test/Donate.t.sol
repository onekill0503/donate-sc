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

    function setUp() public {
        donate = new Donate(address(platform));
        MUSDE = new MockUSDE(owner);
        MSUSDE = new MockSUSDE(owner);

        vault = new Vault(address(MSUSDE), address(donate));

        MUSDE.mint(alex, 1000e18);
        MUSDE.mint(asep, 1000e18);
        MUSDE.mint(budi, 1000e18);

        MUSDE.updateVault(address(vault));
        MSUSDE.updateVault(address(vault));
        donate.updateVaultContract(address(vault));
        donate.addAllowedDonationToken(address(MUSDE));
    }

    function test_Donate() public {
        /**
         * Check if owner is correct
         * Check if platform is correct
         * Check is token is allowed
         * User will donate with different amount to Content Creator
         * Check total creator token in vault
         * Initial exchange rate is 89e16
         */
        assertEq(donate.owner(), owner);
        assertEq(donate.platformAddress(), platform);

        assert(donate.isTokenAllowed(address(MUSDE)));

        vm.startPrank(asep);
        MUSDE.approve(address(donate), 100e18);
        MUSDE.approve(address(vault), 100e18);
        donate.donate(100e18, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.startPrank(budi);
        MUSDE.approve(address(donate), 200e18);
        MUSDE.approve(address(vault), 200e18);
        donate.donate(200e18, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.startPrank(asep);
        MUSDE.approve(address(donate), 100e18);
        MUSDE.approve(address(vault), 100e18);
        donate.donate(100e18, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.prank(owner);
        vault.updateExchangeRate(93e16);
        vm.stopPrank();

        vm.startPrank(budi);
        MUSDE.approve(address(donate), 200e18);
        MUSDE.approve(address(vault), 200e18);
        donate.donate(200e18, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.prank(owner);
        vault.updateExchangeRate(95e16);
        vm.stopPrank();

        vm.startPrank(asep);
        MUSDE.approve(address(donate), 300e18);
        MUSDE.approve(address(vault), 300e18);
        donate.donate(300e18, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.startPrank(budi);
        MUSDE.approve(address(donate), 100e18);
        MUSDE.approve(address(vault), 100e18);
        donate.donate(100e18, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.startPrank(alex);
        (uint256 lockedToken,) = vault.getCreatorTokens(address(alex));
        assertEq(lockedToken, 957980000000000000000);
        vm.stopPrank();

        vm.prank(asep);
        uint256 percentage = donate.getYield(address(asep));
        console.log("Percentage: ", percentage);
    }
}
