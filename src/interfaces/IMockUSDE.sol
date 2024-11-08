// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMockUSDE {
    /**
     * @notice mint USDE and this function should called from vault contract
     * @param to wallet address to receive minted USDE
     * @param amount amount of USDE to mint
     * @return status status of mint process
     */
    function mintUSDEFromVault(address to, uint256 amount) external returns (bool);
    /**
     * @notice burn USDE and this function should called from vault contract
     * @param amount amount of USDE to burn
     * @return status status of burn process
     */
    function burnUSDEFromVault(uint256 amount) external returns (bool);
}
