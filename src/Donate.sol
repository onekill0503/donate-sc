// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IVault.sol";
/**
 * @title Donate
 * @author To De Moon Team
 * @notice This Contract is used for donation and store the donation data
 * @custom:experimental This is an experimental contract
 */

contract Donate {
    /**
     * @notice Donation Record Struct to record donation data
     */
    struct DonationRecord {
        address to; // creator wallet address
        uint256 amount; // donation amount
        address token; // donation token address
        uint256 vaultIndex; // index array of locked token in vault contract
        uint256 claimed; // claimed amount of donation
        uint256 grossAmount; // gross amount of donation
        uint256 lockedDonaturYield; // Donatur Yield Locked Value (when creator claim, the donatur yield portion will be store here)
    }
    /**
     * @notice Donatur Struct to record donatur data
     */

    struct Donatur {
        address donatur; // donatur wallet address
        uint256 amount; // donation amount
        address token; // donation token address
    }

    /**
     * @notice Variables to store total donations
     */
    uint256 public totalDonations;
    /**
     * @notice Variables to store total withdraw
     */
    uint256 public totalWithdraw;
    /**
     * @notice Variables to store owner address
     */
    address public owner;
    /**
     * @notice Variables to store platform address
     */
    address public platformAddress;
    /**
     * @notice Platform Fees Percentage (fixed to 5%), platform fees will be deducted when user donate
     */
    uint256 public platformFees = 5;
    /**
     * @notice creator Fees Percentage (fixed to 30%), creator fees will be deducted when creator claim donation
     */
    uint256 public creatorPercentage = 30;
    /**
     * @notice yield Percentage (fixed to 75%), this is donatur yield percentage for cashback
     */
    uint256 public yieldPercentage = 75;

    event Donation(address indexed donor, uint256 amount);
    event WithdrawDonation(address indexed donor, uint256 amount);
    event addAllowedDonationTokenEvent(address indexed token);
    event removeAllowedDonationTokenEvent(address indexed token);

    /**
     * @notice Donation Mapping to store donation data
     */
    mapping(address => mapping(address => uint256)) public donations;
    /**
     * @notice Donated Record for each donatur based on donatur wallet address as a key
     */
    mapping(address => DonationRecord[]) public donatedAmount;
    /**
     * @notice Donatur Mapping to store donatur data based creator address as a key
     */
    mapping(address => Donatur[]) public donatur;
    /**
     * @notice Allowed Donation Token Mapping to store allowed donation token
     */
    mapping(address => bool) public allowedDonationToken;
    /**
     * @notice Allowed Donation Token Array to store allowed donation token
     */
    address[] public allowedDonationTokens;
    /**
     * @notice Vault Contract Address
     */
    address public vaultContract;

    /**
     * @notice Constructor to initialize owner and platform address
     * @param _platformAddress platform wallet address to receive platform fees
     */
    constructor(address _platformAddress) {
        owner = msg.sender;
        platformAddress = _platformAddress;
    }

    /**
     * @notice Donate function to donate token to creator
     * @param _amount Donation amount for creator
     * @param _to Creator wallet address
     * @param _token donation token address (ex: USDe)
     */
    function donate(uint256 _amount, address _to, address _token) external {
        require(allowedDonationToken[_token], "Donate: token not allowed");
        require(_amount > 0, "Donate: amount must be greater than 0");

        uint256 _vaultIndex =
            IVault(vaultContract).depositToVault(_to, msg.sender, _amount, _token, donatedAmount[msg.sender].length);
        require(_vaultIndex >= 0, "Donate: deposit failed");

        // Calculate the net amount ( amount - platform fees )
        uint256 _platformAmount = (_amount * platformFees / 100);
        uint256 _netAmount = _amount - _platformAmount;
        DonationRecord memory _donationRecord = DonationRecord({
            to: _to,
            amount: _netAmount,
            token: _token,
            vaultIndex: _vaultIndex,
            claimed: 0,
            grossAmount: _amount,
            lockedDonaturYield: 0
        });
        Donatur memory _donatur = Donatur({donatur: msg.sender, amount: _netAmount, token: _token});

        donatedAmount[msg.sender].push(_donationRecord);
        donatur[_to].push(_donatur);

        donations[_to][_token] += _amount;
        totalDonations += _amount;

        emit Donation(msg.sender, _amount);
    }

    /**
     * @notice Withdraw function to withdraw donation from creator
     * @param _amount Amount of token to withdraw
     * @param _token token contract address to withdraw
     */
    function withdraw(uint256 _amount, address _token) external {
        require(allowedDonationToken[_token], "Donate: token not allowed");

        IVault(vaultContract).withdrawFromVault(msg.sender, _amount, _token);

        totalWithdraw += _amount;
        emit WithdrawDonation(msg.sender, _amount);
    }

    /**
     * @notice get total creator donation based on creator wallet address
     * @param _user creator address
     * @return length total donation record data count
     */
    function getTotalDonations(address _user) external view returns (uint256) {
        return donatur[_user].length;
    }

    /**
     * @notice get Donatur Data based on creator wallet address and index of donatur array
     * @param _user creator wallet address
     * @param _index index of donatur array
     * @return _donatur donatur wallet address
     * @return _amount donation amount
     */
    function getDonaturData(address _user, uint256 _index) external view returns (address, uint256) {
        return (donatur[_user][_index].donatur, donatur[_user][_index].amount);
    }

    /**
     * @notice Function to add allowed donation token
     * @param _token token contract address
     */
    function addAllowedDonationToken(address _token) external {
        require(msg.sender == owner, "Donate: only owner can add token");
        allowedDonationToken[_token] = true;
        allowedDonationTokens.push(_token);

        emit addAllowedDonationTokenEvent(_token);
    }

    /**
     * @notice Function to change owner of the contract
     * @param _newOwner new owner address
     */
    function changeOwner(address _newOwner) external {
        require(msg.sender == owner, "Donate: only owner can change owner");
        owner = _newOwner;
    }

    /**
     * @notice Function to remove allowed donation token
     * @param _token token contract address
     */
    function removeAllowedDonationToken(address _token) external {
        require(msg.sender == owner, "Donate: only owner can remove token");
        allowedDonationToken[_token] = false;

        uint256 _removedIndex = allowedDonationTokens.length;
        for (uint256 i = 0; i < allowedDonationTokens.length; i++) {
            if (allowedDonationTokens[i] == _token) {
                _removedIndex = i;
                break;
            }
        }

        require(_removedIndex < allowedDonationTokens.length, "Donate: token not found");

        for (uint256 i = _removedIndex; i < allowedDonationTokens.length - 1; i++) {
            allowedDonationTokens[i] = allowedDonationTokens[i + 1];
        }

        allowedDonationTokens.pop();

        emit removeAllowedDonationTokenEvent(_token);
    }

    /**
     * @notice function to check is token allowed for donation or not
     * @param _token token contract address
     * @return status status of token is allowed or not
     */
    function isTokenAllowed(address _token) external view returns (bool) {
        return allowedDonationToken[_token];
    }

    /**
     * @notice function to update vault contract address
     * @param _vaultContract new vault contract address
     */
    function updateVaultContract(address _vaultContract) external {
        require(msg.sender == owner, "Donate: only owner can update vault contract");
        vaultContract = _vaultContract;
    }

    /**
     * @notice function to update total withdraw amount from vault
     * @param _amount amount of token to update
     * @return status status of update total withdraw
     */
    function updateTotalWithdrawFromVault(uint256 _amount) external returns (bool) {
        require(msg.sender == vaultContract, "Donate: only vault contract can update total withdraw");
        totalWithdraw += _amount;
        return true;
    }

    /**
     * @notice function to get yield amount from active donation user
     * @param _user user wallet address
     * @return _yield yield amount deducted by yeild percentage
     */
    function getYield(address _user) external view returns (uint256) {
        uint256 _yield = 0;
        uint256 _yieldFromVault = 0;
        uint256 _unClaimedPercentage = 0;
        for (uint256 i = donatedAmount[_user].length - 1; i >= 0; i--) {
            if (
                donatedAmount[_user][i].claimed == donatedAmount[_user][i].amount
                    && donatedAmount[_user][i].lockedDonaturYield == 0
            ) break;
            _yieldFromVault += IVault(vaultContract).getYieldByIndex(_user, donatedAmount[_user][i].vaultIndex);
            _unClaimedPercentage = (donatedAmount[_user][i].amount - donatedAmount[_user][i].claimed) / 1e18;
            _yieldFromVault = _yieldFromVault * _unClaimedPercentage / 100;
            _yield += donatedAmount[_user][i].lockedDonaturYield > 0
                ? _yieldFromVault
                : ((_yieldFromVault * yieldPercentage) / 100);
        }
        // return percentage of yield
        return _yield;
    }

    /**
     * @notice function to update donate record at Donate smartcontract
     * @param _user donatur wallet address
     * @param _index index of Donatur Record array
     * @param _claimed amount claimed token by creator
     * @param _lockedDonaturYield donatur yield locked amount
     */
    function updateDonatedAmount(address _user, uint256 _index, uint256 _claimed, uint256 _lockedDonaturYield)
        external
    {
        require(msg.sender == vaultContract, "Donate: only vault contract can update donated amount");
        donatedAmount[_user][_index].claimed = _claimed;
        donatedAmount[_user][_index].lockedDonaturYield = _lockedDonaturYield;
    }
    /**
     * @notice function is used to withdraw all donatur yield from vault
     */

    function withdrawDonaturYield() external {
        uint256 _yield = 0;
        uint256 _yieldFromVault = 0;
        uint256 _unClaimedPercentage = 0;
        for (uint256 i = donatedAmount[msg.sender].length - 1; i >= 0; i--) {
            if (
                donatedAmount[msg.sender][i].claimed == donatedAmount[msg.sender][i].amount
                    && donatedAmount[msg.sender][i].lockedDonaturYield == 0
            ) break;
            _yieldFromVault +=
                IVault(vaultContract).getYieldByIndex(msg.sender, donatedAmount[msg.sender][i].vaultIndex);
            _unClaimedPercentage = (donatedAmount[msg.sender][i].amount - donatedAmount[msg.sender][i].claimed) / 1e18;
            _yieldFromVault = _yieldFromVault * _unClaimedPercentage / 100;
            _yield += donatedAmount[msg.sender][i].lockedDonaturYield > 0
                ? _yieldFromVault
                : ((_yieldFromVault * yieldPercentage) / 100);

            donatedAmount[msg.sender][i].lockedDonaturYield = 0;
        }

        require(_yield > 0, "Donate: no yield to withdraw");
        require(IVault(vaultContract).withdrawYield(msg.sender, _yield), "Donate: withdraw yield failed");
    }
}
