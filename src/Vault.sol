// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./interfaces/IDonate.sol";
import "./interfaces/IMockSUSDE.sol";
import "./interfaces/IMockUSDE.sol";

abstract contract Vault is IDonate, IMockSUSDE, IMockUSDE {
    struct LockedToken{
        uint256 amount;
        uint256 lockUntil;
    }

    address public owner;
    address public vaultToken;
    address public donateContract;
    uint256 public totalLockBlocks = 215000; // this is 1 month in block based on average block per day

    // Mocked exchange rate for testing purposes , 1 USDe : 0.98 sUSDe
    uint256 public mockedExhcangeRate = 98e16;

    mapping(address => LockedToken[]) public lockedTokens;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner, "Vault: only owner can change owner");
        owner = _newOwner;
    }

    function depositToVault(address _user, uint256 _amount, address _tokenAddress) public returns(bool){
        require(IDonate(donateContract).isActiveUser(_user), "Vault: user is not active");
        require(IERC20(_tokenAddress).transferFrom(msg.sender, address(this), _amount), "Vault: transfer failed");

        uint256 _lockUntil = block.number + totalLockBlocks;
        uint256 _sUSDeAmount = _amount * mockedExhcangeRate / 1e18;

        LockedToken memory _lockedToken = LockedToken({amount: _sUSDeAmount, lockUntil: _lockUntil});
        lockedTokens[_user].push(_lockedToken);

        // burn token address then mint sUSDe
        ERC20Burnable(_tokenAddress).burn(_amount);
        require(IMockSUSDE(vaultToken).mintSUSDEFromVault(address(this), _sUSDeAmount), "Vault: transfer failed");
        return true;
    }

    function withdrawFromVault(uint256 _amount, address _toToken) public {
        require(IDonate(donateContract).isTokenAllowed(_toToken), "Vault: token not allowed");

        uint256 _claimable = 0;
        for(uint256 i = 0; i < lockedTokens[msg.sender].length; i++){
            if(lockedTokens[msg.sender][i].lockUntil <= block.number){
                _claimable += lockedTokens[msg.sender][i].amount;
                lockedTokens[msg.sender][i] = lockedTokens[msg.sender][lockedTokens[msg.sender].length - 1];
                lockedTokens[msg.sender].pop();
            }
        }
        require(_claimable >= _amount, "Vault: not enough claimable amount");
        
        uint256 _usdeAmount = _amount * 1e18 / mockedExhcangeRate;
        ERC20Burnable(vaultToken).burn(_amount);
        require(IMockUSDE(_toToken).mintUSDEFromVault(msg.sender, _usdeAmount), "Vault: mint failed");
        require(IERC20(_toToken).transfer(msg.sender, _usdeAmount), "Vault: transfer failed");
    }

    function updateVault(address _token, address _donateContract) public {
        require(msg.sender == owner, "Vault: only owner can update vault token");
        vaultToken = _token;
        donateContract = _donateContract;
    }

    function userToken(address _user) public view returns(uint256, uint256){
        uint256 totalClaimable = 0;
        uint256 totalLocked = 0;
        for(uint256 i = 0; i < lockedTokens[_user].length; i++){
            if(lockedTokens[_user][i].lockUntil <= block.number){
                totalClaimable += lockedTokens[_user][i].amount;
            }else{
                totalLocked += lockedTokens[_user][i].amount;
            }
        }
        return (totalClaimable, totalLocked);
    }

}