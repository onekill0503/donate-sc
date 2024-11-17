// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDonate {
    function donate(uint256 _amount, address _to, address _token) external;
    function setMerkleRoot(bytes32 _merkleRoot) external;
    function initiateWithdraw(address _shares) external;
    function batchWithdraw() external;
    function unstakeBatchWithdraw() external;
    function addAllowedDonationToken(address _token) external;
    function changeOwner(address _newOwner) external;
    function removeAllowedDonationToken(address _token) external;
    function getYield(address _user) external view returns (uint256);
    function updateToken(address _sUSDeToken, address _USDeToken) external;
    function claim(uint256 _amount, bytes32[] calldata _proof) external;
    function lastBatchWithdraw() external view returns (uint256);

    /**
     * @notice function to check is token allowed or not
     * @param _token token address
     * @return status token status
     */
    function isTokenAllowed(address _token) external view returns (bool);
}
