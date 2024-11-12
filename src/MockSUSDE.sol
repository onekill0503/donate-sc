// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MockSUSDE is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    /**
     * @notice vault contract address
     */
    address public vaultContract;

    /**
     * @notice constructor to create SUSDE token
     * @param initialOwner initial owner of contract
     */
    constructor(address initialOwner) ERC20("MockSUSDE", "MSUSDE") Ownable(initialOwner) ERC20Permit("MockSUSDE") {}

    /**
     * @notice function to mint SUSDE ( only owner of contract can call this function )
     * @param to wallet address to receive minted SUSDE
     * @param amount amount of SUSDE to mint
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
     * @notice mint SUSDE and this function should called from vault contract
     * @param to wallet address to receive minted SUSDE
     * @param amount amount of SUSDE to mint
     * @return status status of mint process
     */
    function mintSUSDEFromVault(address to, uint256 amount) external returns (bool) {
        // require(msg.sender == vaultContract, "MockUSDE: only vault can mint");
        _mint(to, amount);

        return true;
    }

    /**
     * @notice burn SUSDE and this function should called from vault contract
     * @param amount amount of SUSDE to burn
     * @return status status of burn process
     */
    function burnSUSDEFromVault(uint256 amount) external returns (bool) {
        require(msg.sender == vaultContract, "MockUSDE: only vault can burn");
        _burn(msg.sender, amount);
        return true;
    }
}
