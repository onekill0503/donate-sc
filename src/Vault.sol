// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./interfaces/IDonate.sol";
import "./interfaces/IMockSUSDE.sol";
import "./interfaces/IMockUSDE.sol";

contract Vault {
    struct LockedToken {
        address from;
        uint256 amountsUSDe;
        uint256 amountUSDe;
        uint256 exchangeRateSnapshot;
        uint256 lockUntil;
        uint256 donateRecordIndex;
        uint256 claimed;
    }

    address public owner;
    address public vaultToken;
    address public donateContract;
    uint256 public totalLockBlocks;

    // Mocked exchange rate for testing purposes , 1 USDe : 0.98 sUSDe
    uint256 public mockedExhcangeRate = 98e16;

    mapping(address => LockedToken[]) public lockedTokens;

    constructor(address _vaultToken, address _donateContract) {
        owner = msg.sender;
        vaultToken = _vaultToken;
        donateContract = _donateContract;
        totalLockBlocks = 215000; // 1 month in block based on average block per day
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner, "Vault: only owner can change owner");
        owner = _newOwner;
    }

    function depositToVault(
        address _to,
        address _from,
        uint256 _amount,
        address _tokenAddress,
        uint256 _donateRecordIndex
    ) public returns (uint256) {
        require(IDonate(donateContract).isActiveUser(_from), "Vault: user is not active");
        require(IERC20(_tokenAddress).transferFrom(_from, address(this), _amount), "Vault: transfer failed");

        uint256 _lockUntil = block.number + totalLockBlocks;
        uint256 _sUSDeAmount = _amount * mockedExhcangeRate / 1e18;
        uint256 _index = lockedTokens[_to].length;

        LockedToken memory _lockedToken = LockedToken({
            amountUSDe: _amount,
            amountsUSDe: _sUSDeAmount,
            exchangeRateSnapshot: mockedExhcangeRate,
            lockUntil: _lockUntil,
            from: _from,
            donateRecordIndex: _donateRecordIndex,
            claimed: 0
        });
        lockedTokens[_to].push(_lockedToken);

        // burn token address then mint sUSDe - real case is exchange USDe to sUSDe
        ERC20Burnable(_tokenAddress).burn(_amount);
        require(IMockSUSDE(vaultToken).mintSUSDEFromVault(address(this), _sUSDeAmount), "Vault: transfer failed");
        return _index;
    }

    function updateVault(address _token, address _donateContract) public {
        require(msg.sender == owner, "Vault: only owner can update vault token");
        vaultToken = _token;
        donateContract = _donateContract;
    }

    function getCreatorTokens(address _creator) public view returns (uint256, uint256) {
        uint256 _lockedTokens = 0;
        uint256 _unlockedTokens = 0;
        uint256 _lockedYield = 0;
        uint256 _unlockedYield = 0;
        uint256 _creatorPercentage = IDonate(donateContract).creatorPercentage();
        for (uint256 i = 0; i < lockedTokens[_creator].length; i++) {
            uint256 _yield = getYieldByIndex(_creator, i);
            if (lockedTokens[_creator][i].lockUntil > block.number) {
                _lockedTokens += lockedTokens[_creator][i].amountUSDe;
                _lockedYield += _yield * _creatorPercentage / 1e18;
            } else {
                _unlockedTokens += lockedTokens[_creator][i].amountUSDe;
                _unlockedYield += _yield * _creatorPercentage / 1e18;
            }
        }
        return ((_lockedTokens + _lockedYield), (_unlockedTokens + _unlockedYield));
    }

    function getYieldByIndex(address _creator, uint256 _index) public view returns (uint256) {
        LockedToken memory _lockedToken = lockedTokens[_creator][_index];
        uint256 _yield = _lockedToken.amountsUSDe * (_lockedToken.exchangeRateSnapshot - mockedExhcangeRate) / 1e18;
        return _yield;
    }

    function updateLockBlocks(uint256 _blocks) public {
        require(msg.sender == owner, "Vault: only owner can update lock blocks");
        totalLockBlocks = _blocks;
    }

    function updateExchangeRate(uint256 _rate) public {
        require(msg.sender == owner, "Vault: only owner can update exchange rate");
        mockedExhcangeRate = _rate;
    }
}
