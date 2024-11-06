// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVault {
    function depositToVault(address _user, uint256 _amount, address _tokenAddress) external returns (bool);
}
