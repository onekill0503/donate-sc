// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVault {
    /**
     * @notice function to deposit token to vault
     * @param _to creator wallet address
     * @param _from donatur wallet address
     * @param _amount donate amount
     * @param _tokenAddress donated token address
     * @param _donateRecordIndex index of donate record array
     * @return index return index of locked tokens array
     */
    function depositToVault(
        address _to,
        address _from,
        uint256 _amount,
        address _tokenAddress,
        uint256 _donateRecordIndex
    ) external returns (uint256);
    /**
     * @notice function to get creator yield by locked token index array
     * @param _user creator wallet address
     * @param _index locked token index array
     * @return yield creator yield
     */
    function getYieldByIndex(address _user, uint256 _index) external view returns (uint256);
    /**
     * @notice function to withdraw creator donation include creator yield
     * @param _to creator wallet address to receive token
     * @param _amount amount to withdraw
     * @param _token token contract address
     */
    function withdrawFromVault(address _to, uint256 _amount, address _token) external;
}
