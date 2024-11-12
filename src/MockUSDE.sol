// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MockUSDE is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    /**
     * @notice vault contract address
     */
    address public vaultContract;

    /**
     * @notice constructor to create USDE token
     * @param initialOwner initial owner of contract
     */
    constructor(address initialOwner) ERC20("MockUSDE", "MUSDE") Ownable(initialOwner) ERC20Permit("MockUSDE") {}

    /**
     * @notice function to mint USDE ( only owner of contract can call this function )
     * @param to wallet address to receive minted USDE
     * @param amount amount of USDE to mint
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @notice update vault contract address ( only owner of contract can call this function )
     * @param _vaultContract new vault contract address
     */
    function updateVault(address _vaultContract) external onlyOwner {
        vaultContract = _vaultContract;
    }

    /**
     * @notice mint USDE and this function should called from vault contract
     * @param to wallet address to receive minted USDE
     * @param amount amount of USDE to mint
     * @return status status of mint process
     */
    function mintUSDEFromVault(address to, uint256 amount) external returns (bool) {
        require(msg.sender == vaultContract, "MockUSDE: only vault can mint");
        _mint(to, amount);

        return true;
    }

    /**
     * @notice burn USDE and this function should called from vault contract
     * @param amount amount of USDE to burn
     * @return status status of burn process
     */
    function burnUSDEFromVault(uint256 amount) external returns (bool) {
        require(msg.sender == vaultContract, "MockUSDE: only vault can burn");
        _burn(msg.sender, amount);
        return true;
    }
}
