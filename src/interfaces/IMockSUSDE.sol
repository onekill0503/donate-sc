// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMockSUSDE {
    /**
     * @notice mint SUSDE and this function should called from vault contract
     * @param to wallet address to receive minted SUSDE
     * @param amount amount of SUSDE to mint
     * @return status status of mint process
     */
    function mintSUSDEFromVault(address to, uint256 amount) external returns (bool);
    /**
     * @notice burn SUSDE and this function should called from vault contract
     * @param amount amount of SUSDE to burn
     * @return status status of burn process
     */
    function burnSUSDEFromVault(uint256 amount) external returns (bool);
}
