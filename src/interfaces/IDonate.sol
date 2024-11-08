// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDonate {
    function isActiveUser(address _user) external view returns (bool);
    function isTokenAllowed(address _token) external view returns (bool);
    function updateTotalWidthdrawFromVault(uint256 _amount) external returns (bool);
}
