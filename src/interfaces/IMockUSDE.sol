// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMockUSDE {
    function mintUSDEFromVault(address to, uint256 amount) external returns (bool);
    function burnUSDEFromVault(uint256 amount) external returns (bool);
}
