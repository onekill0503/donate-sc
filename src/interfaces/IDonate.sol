// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDonate {
    function donate(uint256 _amount, address _to) external;
    function setMerkleRoot(bytes32 _merkleRoot) external;
    function initiateWithdraw(address _shares) external;
    function batchWithdraw() external;
    function unstakeBatchWithdraw() external;
    function changeOwner(address _newOwner) external;
    function getYield(address _user) external view returns (uint256);
    function claim(uint256 _amount, bytes32[] calldata _proof) external;
    function lastBatchWithdraw() external view returns (uint256);
    function creatorPercentage() external view returns (uint256);
    function gifterPercentage() external view returns (uint256);
    function withdrawStatus() external view returns (bool);

    /**
     * @notice function to check is token allowed or not
     * @param _token token address
     * @return status token status
     */
    function isTokenAllowed(address _token) external view returns (bool);
}
