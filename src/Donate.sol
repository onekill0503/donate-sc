// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ISUSDE.sol";

/**
 * @title Donate
 * @author To De Moon Team
 * @notice This Contract is used for donation and store the donation data
 * @custom:experimental This is an experimental contract
 */
contract Donate {
    /**
     * @notice Gifters Record Struct to Gifter data
     */
    struct GiftersRecord {
        uint256 donatedAmount; // donation amount deducted by platform fees
        uint256 totalShares; // total shares of donation
        uint256 inactiveYield; // Yield amount from withraw donation
        uint256 grossDonatedAmount; // gross amount of donation
    }

    struct CreatorsRecord {
        uint256 totalDonation; // total donation amount
        uint256 claimableShares; // claimable donation amount
    }

    struct LockedBalances {
        address creatorAddress;
        uint256 shares;
        uint256 lockUntil;
        bool unlocked;
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
     * @notice yield Percentage (fixed to 70%), this is donatur yield percentage for cashback
     */
    uint256 public gifterPercentage = 70;

    /**
     * @notice lock period for donation (fixed to 30 days) in seconds
     */
    uint256 public lockPeriod = 1987200;

    LockedBalances[] public lockedBalances;

    event Donation(address indexed donor, uint256 amount);
    event WithdrawDonation(address indexed donor, uint256 amount);
    event addAllowedDonationTokenEvent(address indexed token);
    event removeAllowedDonationTokenEvent(address indexed token);

    error DONATE__NOT_ALLOWED_TOKEN(address token);
    error DONATE__AMOUNT_ZERO();
    error DONATE__INSUFFICIENT_BALANCE(address wallet);
    error DONATE__WALLET_NOT_ALLOWED(address wallet);

    /**
     * @notice Donation Mapping to store donation data
     */
    mapping(address => GiftersRecord) public gifters;
    mapping(address => CreatorsRecord) public creators;
    /**
     * @notice Allowed Donation Token Mapping to store allowed donation token
     */
    mapping(address => bool) public allowedDonationToken;
    /**
     * @notice Allowed Donation Token Array to store allowed donation token
     */
    address[] public allowedDonationTokens;

    ISUSDE public sUSDeToken;

    /**
     * @notice Constructor to initialize owner and platform address
     * @param _platformAddress platform wallet address to receive platform fees
     */
    constructor(address _platformAddress, address _sUSDeToken) {
        owner = msg.sender;
        platformAddress = _platformAddress;
        sUSDeToken = ISUSDE(_sUSDeToken);
    }

    /**
     * @notice Donate function to donate token to creator
     * @param _amount Donation amount for creator
     * @param _to Creator wallet address
     * @param _token donation token address (ex: USDe)
     */
    function donate(uint256 _amount, address _to, address _token) external {
        if (_amount == 0) revert DONATE__AMOUNT_ZERO();
        if (!allowedDonationToken[_token]) revert DONATE__NOT_ALLOWED_TOKEN(_token);

        IERC20 donationToken = IERC20(_token);
        if (donationToken.balanceOf(msg.sender) < _amount) revert DONATE__INSUFFICIENT_BALANCE(msg.sender);

        uint256 _platformFees = (_amount * platformFees) / 100;
        uint256 _netAmount = _amount - _platformFees;
        uint256 _gifterAmount = (_netAmount * gifterPercentage) / 100;
        uint256 _netShares = sUSDeToken.convertToShares(_netAmount);
        uint256 _gifterShares = sUSDeToken.convertToShares(_gifterAmount);

        gifters[msg.sender].donatedAmount += _gifterAmount;
        gifters[msg.sender].totalShares += _gifterShares;
        gifters[msg.sender].grossDonatedAmount += _amount;
        gifters[msg.sender].inactiveYield += 0;

        creators[_to].totalDonation += _netAmount;

        lockedBalances.push(
            LockedBalances({
                creatorAddress: _to,
                shares: _netShares,
                lockUntil: block.timestamp + lockPeriod,
                unlocked: false
            })
        );

        donationToken.transferFrom(msg.sender, platformAddress, _platformFees);
        sUSDeToken.deposit(sUSDeToken.convertToShares(_netAmount), address(this));

        updateLockedBalances();
        emit Donation(msg.sender, _amount);
    }

    function updateLockedBalances() private {
        for (uint256 i = 0; i < lockedBalances.length; i++) {
            if (lockedBalances[i].lockUntil > block.timestamp) break;
            if (lockedBalances[i].lockUntil < block.timestamp && !lockedBalances[i].unlocked) {
                lockedBalances[i].unlocked = true;
                creators[lockedBalances[i].creatorAddress].claimableShares += lockedBalances[i].shares;
            }
        }
    }

    /**
     * @notice Withdraw function to withdraw donation from creator
     * @param _shares Amount of token to withdraw
     */
    function creatorWithdraw(uint256 _shares) external {
        if (_shares == 0) revert DONATE__AMOUNT_ZERO();
        if (creators[msg.sender].claimableShares < _shares) revert DONATE__INSUFFICIENT_BALANCE(msg.sender);

        uint256 _assets = sUSDeToken.convertToAssets(_shares);
        uint256 _gifterShares = _shares * gifterPercentage / 100;

        sUSDeToken.cooldownShares(_shares);
        emit WithdrawDonation(msg.sender, _shares);
    }

    /**
     * @notice Function to add allowed donation token
     * @param _token token contract address
     */
    function addAllowedDonationToken(address _token) external {
        if (msg.sender != owner) revert DONATE__WALLET_NOT_ALLOWED(msg.sender);
        allowedDonationToken[_token] = true;
        allowedDonationTokens.push(_token);

        emit addAllowedDonationTokenEvent(_token);
    }

    /**
     * @notice Function to change owner of the contract
     * @param _newOwner new owner address
     */
    function changeOwner(address _newOwner) external {
        if (msg.sender != owner) revert DONATE__WALLET_NOT_ALLOWED(msg.sender);
        owner = _newOwner;
    }

    /**
     * @notice Function to remove allowed donation token
     * @param _token token contract address
     */
    function removeAllowedDonationToken(address _token) external {
        if (msg.sender != owner) revert DONATE__WALLET_NOT_ALLOWED(msg.sender);
        allowedDonationToken[_token] = false;

        uint256 _removedIndex = allowedDonationTokens.length;
        for (uint256 i = 0; i < allowedDonationTokens.length; i++) {
            if (allowedDonationTokens[i] == _token) {
                _removedIndex = i;
                break;
            }
        }

        if (_removedIndex == allowedDonationTokens.length) revert DONATE__NOT_ALLOWED_TOKEN(_token);

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
     * @notice function to get yield amount from active donation user
     * @param _user user wallet address
     * @return _yield yield amount deducted by yeild percentage
     */
    function getYield(address _user) external view returns (uint256) {
        uint256 _totalUSDE = sUSDeToken.previewRedeem(gifters[_user].totalShares);
        uint256 _yield = gifters[_user].inactiveYield + (_totalUSDE - gifters[_user].donatedAmount);
        return _yield;
    }

    function updateSUSDeToken(address _sUSDeToken) external {
        if (msg.sender != owner) revert DONATE__WALLET_NOT_ALLOWED(msg.sender);
        sUSDeToken = ISUSDE(_sUSDeToken);
    }
}
