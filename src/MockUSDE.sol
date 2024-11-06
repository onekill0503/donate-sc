// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MockUSDE is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    address public vaultContract;

    constructor(address initialOwner) ERC20("MockUSDE", "MUSDE") Ownable(initialOwner) ERC20Permit("MockUSDE") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // =================== Added function ===================
    // Function below is mocked function,
    // the real function is exchange to the token

    function updateVault(address _vaultContract) public onlyOwner {
        vaultContract = _vaultContract;
    }

    function mintUSDEFromVault(address to, uint256 amount) public returns (bool) {
        require(msg.sender == vaultContract, "MockUSDE: only vault can mint");
        _mint(to, amount);

        return true;
    }
}
