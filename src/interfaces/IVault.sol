// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVault {
    function depositToVault(
        address _to,
        address _from,
        uint256 _amount,
        address _tokenAddress,
        uint256 _donateRecordIndex
    ) external returns (uint256);
    function getYieldByIndex(address _user, uint256 _index) external view returns (uint256);
    function withdrawFromVault(address _to, uint256 _amount, address _token) external returns (uint256);
}
