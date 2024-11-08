// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDonate {
    /**
     * @notice function to check is user active or not
     * @param _user user address
     * @return status user status
     */
    function isActiveUser(address _user) external view returns (bool);
    /**
     * @notice function to check is token allowed or not
     * @param _token token address
     * @return status token status
     */
    function isTokenAllowed(address _token) external view returns (bool);
    /**
     * @notice function to update total withdraw amount from vault
     * @param _amount amount of token to update
     * @return status status of update total withdraw
     */
    function updateTotalWidthdrawFromVault(uint256 _amount) external returns (bool);
    /**
     * @notice function to get percentage of creator yield portion
     * @return creatorPercentage creator yield percentage
     */
    function creatorPercentage() external view returns (uint256);
    /**
     * @notice function to get percentage of donatur yield portion
     * @return donaturPercentage donatur yield percentage
     */
    function yieldPercentage() external view returns (uint256);
}
