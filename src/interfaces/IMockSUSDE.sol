// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMockSUSDE {
    function mintSUSDEFromVault(address to, uint256 amount) external returns (bool);
    function burnSUSDEFromVault(uint256 amount) external returns (bool);
}
