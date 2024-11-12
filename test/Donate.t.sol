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

        MUSDE.mint(alex, 1000);
        MUSDE.mint(asep, 1000);
        MUSDE.mint(budi, 1000);

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
         */
        assertEq(donate.owner(), owner);
        assertEq(donate.platformAddress(), platform);

        assert(donate.isTokenAllowed(address(MUSDE)));

        vm.startPrank(asep);
        MUSDE.approve(address(donate), 100);
        MUSDE.approve(address(vault), 100);
        donate.donate(100, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.startPrank(budi);
        MUSDE.approve(address(donate), 200);
        MUSDE.approve(address(vault), 200);
        donate.donate(200, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.startPrank(asep);
        MUSDE.approve(address(donate), 100);
        MUSDE.approve(address(vault), 100);
        donate.donate(100, address(alex), address(MUSDE));
        vm.stopPrank();

        vm.startPrank(alex);
        (uint256 lockedToken,) = vault.getCreatorTokens(address(alex));
        assertEq(lockedToken, 400);
        vm.stopPrank();
    }
}
