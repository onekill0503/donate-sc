// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./interfaces/IDonate.sol";
import "./interfaces/IMockSUSDE.sol";
import "./interfaces/IMockUSDE.sol";

/**
 * @title Vault
 * @author To De Moon Team
 * @notice This contract is used to store locked token and yield then distribute to creator and donatur
 * @custom:experimental This is an experimental contract
 */
contract Vault {
    /**
     *
     * @notice Locked Token Struct
     */
    struct LockedToken {
        address from; // Donatur Address
        uint256 amountsUSDe; // Amount of sUSDe
        uint256 amountUSDe; // Amount of USDe
        uint256 exchangeRateSnapshot; // Exchange Rate Snapshot
        uint256 lockUntil; // Lock Until Block
        uint256 donateRecordIndex; // Donate Record Index
        uint256 claimed; // Claimed Amount
        uint256 lockedDonaturYield; // Donatur Yield Locked Value (when creator claim, the donatur yield portion will be store here)
    }

    /**
     * @notice owner of the contract
     */
    address public owner;
    /**
     * @notice vault token address
     */
    address public vaultToken;
    /**
     * @notice donate contract address
     */
    address public donateContract;
    /**
     * @notice total lock blocks for 1 month
     */
    uint256 public totalLockBlocks;
    /**
     * @notice exchange rate for 1 USDe to sUSDe
     */
    uint256 public mockedExchangeRate = 98e16;
    /**
     * @notice locked token mapping
     */
    mapping(address => LockedToken[]) public lockedTokens;

    /**
     * @notice constructor to create Vault contract
     * @param _vaultToken contract address of token for vault token (yield token , ex: sUSDe)
     * @param _donateContract donation contract address
     */
    constructor(address _vaultToken, address _donateContract) {
        owner = msg.sender;
        vaultToken = _vaultToken;
        donateContract = _donateContract;
        totalLockBlocks = 215000; // 1 month in block based on average block per day
    }

    /**
     * @notice this function is used to change owner of the contract
     * @param _newOwner new owner address
     */
    function changeOwner(address _newOwner) external {
        require(msg.sender == owner, "Vault: only owner can change owner");
        owner = _newOwner;
    }

    /**
     * @notice this function is used to withdraw token from vault to creator
     * @param _to Wallet Address who receive donation
     * @param _amount Amount of Token (name token based on _token) to Withdraw (include yield)
     * @param _token Token Contract address for output
     */
    function withdrawFromVault(address _to, uint256 _amount, address _token) external {
        require(msg.sender == donateContract, "Vault: only donate contract can withdraw from vault");
        uint256 _USDeAmount;

        for (uint256 i = lockedTokens[_to].length - 1; i >= 0; i--) {
            if (lockedTokens[_to][i].claimed == lockedTokens[_to][i].amountUSDe) break;
            if (_USDeAmount == _amount) break;
            if (lockedTokens[_to][i].lockUntil < block.number) {
                uint256 _yield = getYieldByIndex(_to, i);
                uint256 _creatorYield = _yield * IDonate(donateContract).creatorPercentage() / 100;
                uint256 _donaturYield = _yield * IDonate(donateContract).yieldPercentage() / 100;
                uint256 _claimedAmount = (lockedTokens[_to][i].amountUSDe - lockedTokens[_to][i].claimed);
                lockedTokens[_to][i].lockedDonaturYield = _donaturYield;
                _USDeAmount += _claimedAmount + _creatorYield;

                IDonate(donateContract).updateDonatedAmount(
                    lockedTokens[_to][i].from, lockedTokens[_to][i].donateRecordIndex, _claimedAmount, _donaturYield
                );
            }
        }

        require(_amount <= _USDeAmount, "Vault: not enough balance");
        uint256 _sUSDeAmount = _amount * 1e18 / mockedExchangeRate;
        require(IMockSUSDE(vaultToken).burnSUSDEFromVault(_sUSDeAmount), "Vault: transfer failed");
        require(IMockUSDE(_token).mintUSDEFromVault(_to, _amount), "Vault: transfer failed");
    }

    /**
     * @notice this function is used to deposit token to vault
     * @param _to Creator Wallet Address who receive donation
     * @param _from Donatur Wallet Address who send donation
     * @param _amount Donate Amount in USDe
     * @param _tokenAddress Token Address for donation
     * @param _donateRecordIndex Array Index for Donation Record at Donate Contract
     */
    function depositToVault(
        address _to,
        address _from,
        uint256 _amount,
        address _tokenAddress,
        uint256 _donateRecordIndex
    ) external returns (uint256) {
        require(msg.sender = donateContract, "Vault: only donate contract can call this function");
        require(IERC20(_tokenAddress).transferFrom(_from, address(this), _amount), "Vault: transfer failed");

        uint256 _lockUntil = block.number + totalLockBlocks;
        uint256 _sUSDeAmount = _amount * mockedExchangeRate / 1e18;
        uint256 _index = lockedTokens[_to].length;

        LockedToken memory _lockedToken = LockedToken({
            amountUSDe: _amount,
            amountsUSDe: _sUSDeAmount,
            exchangeRateSnapshot: mockedExchangeRate,
            lockUntil: _lockUntil,
            from: _from,
            donateRecordIndex: _donateRecordIndex,
            claimed: 0,
            lockedDonaturYield: 0
        });
        lockedTokens[_to].push(_lockedToken);

        require(IMockUSDE(vaultToken).burnUSDEFromVault(_amount), "Vault: transfer failed");
        require(IMockSUSDE(vaultToken).mintSUSDEFromVault(address(this), _sUSDeAmount), "Vault: transfer failed");
        return _index;
    }

    /**
     * @notice this function is used to update vault token and donation contract address
     * @param _token contract address of token for vault token (yield token , ex: sUSDe)
     * @param _donateContract donation contract address
     */
    function updateVault(address _token, address _donateContract) external {
        require(msg.sender == owner, "Vault: only owner can update vault token");
        vaultToken = _token;
        donateContract = _donateContract;
    }

    /**
     * @notice this function is used to get creator locked and unlocked token
     * @param _creator Creator Wallet Address
     * @return _lockedTokens return total Locked Token include locked yield
     * @return _unlockTokens return total Unlocked Token include unlocked yield
     */
    function getCreatorTokens(address _creator) external view returns (uint256, uint256) {
        uint256 _lockedTokens = 0;
        uint256 _unlockedTokens = 0;
        uint256 _lockedYield = 0;
        uint256 _unlockedYield = 0;
        uint256 _creatorPercentage = IDonate(donateContract).creatorPercentage();
        for (uint256 i = lockedTokens[_creator].length - 1; i >= 0; i++) {
            if (lockedTokens[_creator][i].claimed == lockedTokens[_creator][i].amountUSDe) break;
            uint256 _yield = getYieldByIndex(_creator, i);
            if (lockedTokens[_creator][i].lockUntil > block.number) {
                _lockedTokens += lockedTokens[_creator][i].amountUSDe;
                _lockedYield += _yield * _creatorPercentage / 100;
            } else {
                _unlockedTokens += lockedTokens[_creator][i].amountUSDe;
                _unlockedYield += _yield * _creatorPercentage / 100;
            }
        }
        return ((_lockedTokens + _lockedYield), (_unlockedTokens + _unlockedYield));
    }

    /**
     * @notice this function is used to get yield by index of lockedTokens array
     * @param _creator creator address
     * @param _index array index for lockedTokens
     * @return _yield amount of yield in specific lockedTokens index
     */
    function getYieldByIndex(address _creator, uint256 _index) public view returns (uint256) {
        LockedToken memory _lockedToken = lockedTokens[_creator][_index];
        if (_lockedToken.lockedDonaturYield > 0) return _lockedToken.lockedDonaturYield;
        uint256 _yield = _lockedToken.amountsUSDe * (_lockedToken.exchangeRateSnapshot - mockedExchangeRate) / 1e18;
        return _yield;
    }

    /**
     * @notice this function is used to update lock blocks for 1 month
     * @param _blocks total lock blocks for 1 month (based on average block per day)
     */
    function updateLockBlocks(uint256 _blocks) external {
        require(msg.sender == owner, "Vault: only owner can update lock blocks");
        totalLockBlocks = _blocks;
    }

    /**
     * @notice this function is used to update exchange rate for 1 USDe to sUSDe
     * @param _rate exchange rate for 1 USDe to sUSDe (it's just mock for testing)
     */
    function updateExchangeRate(uint256 _rate) external {
        require(msg.sender == owner, "Vault: only owner can update exchange rate");
        mockedExchangeRate = _rate;
    }

    /**
     * @notice function is used to withdraw yield from vault to donatur
     * @param _to donatur wallet address to receive yield
     * @param _amount withdraw amount of yield
     */
    function withdrawYield(address _to, uint256 _amount) external returns (bool) {
        require(msg.sender == donateContract, "Vault: only donate contract can call this function");
        require(IMockSUSDE(vaultToken).burnSUSDEFromVault(_amount), "Vault: transfer failed");
        require(IMockUSDE(vaultToken).mintUSDEFromVault(_to, _amount), "Vault: transfer failed");
        return true;
    }
}
