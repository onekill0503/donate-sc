// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ISUSDE.sol";
import {console} from "forge-std/console.sol";

/**
 * @title Donate
 * @author To De Moon Team
 * @notice This Contract is used for donation and store the donation data
 * @custom:experimental This is an experimental contract
 */
contract Donate is Ownable {
    /**
     * @notice Gifters Record Struct to Gifter data
     */
    struct GiftersRecord {
        uint256 donatedAmount; // donation amount deducted by platform fees
        uint256 totalShares; // total shares of donation
        uint256 grossDonatedAmount; // gross amount of donation
        uint256 lastClaimed; // last claimed timestamp
    }
    /**
     * @notice Creators Record Struct to Creator data
     */

    struct CreatorsRecord {
        uint256 totalDonation; // total donation amount
        uint256 claimableShares; // claimable donation amount
        uint256 lastClaimed; // last claimed timestamp
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
     * @notice batchWithdrawAmount to store total amount to batch withdraw
     */
    uint256 public batchWithdrawAmount = 0;
    /**
     * @notice batchWithdrawMin to store minimum amount to batch withdraw
     */
    uint256 public batchWithdrawMin = 500e18;
    /**
     * @notice lastBatchWithdraw to store last batch withdraw timestamp
     */
    uint256 public lastBatchWithdraw;
    /**
     * @notice Merkle Root Hash to store merkle root hash
     */
    bytes32 public merkleRoot;

    event NewDonation(
        address indexed gifter,
        uint256 grossAmount,
        uint256 netAmount,
        address indexed creator,
        uint256 gifterShares,
        uint256 timestamp
    );
    event InitiateWithdraw(address indexed creator, uint256 shares, uint256 timestamp);
    event ClaimReward(address indexed user, uint256 amount, uint256 timestamp);
    event addAllowedDonationTokenEvent(address indexed token, uint256 timestamp);
    event removeAllowedDonationTokenEvent(address indexed token, uint256 timestamp);

    error DONATE__NOT_ALLOWED_TOKEN(address token);
    error DONATE__AMOUNT_ZERO();
    error DONATE__INSUFFICIENT_BALANCE(address wallet);
    error DONATE__WALLET_NOT_ALLOWED(address wallet);
    error DONATE__BATCH_WITHDRAW_MINIMUM_NOT_REACHED(uint256 batchWithdrawAmount);
    error DONATE__INVALID_MERKLE_PROOF();

    /**
     * @notice Donation Mapping to store donation data
     */
    mapping(address => GiftersRecord) public gifters;
    /**
     * @notice Creators Mapping to store creator data
     */
    mapping(address => CreatorsRecord) public creators;
    /**
     * @notice Allowed Donation Token Mapping to store allowed donation token
     */
    mapping(address => bool) public allowedDonationToken;
    /**
     * @notice Allowed Donation Token Array to store allowed donation token
     */
    address[] public allowedDonationTokens;
    /**
     * @notice sUSDe token address with ISUSDE interface
     */
    ISUSDE public sUSDeToken;
    /**
     * @notice USDe token address with IERC20 interface
     */
    IERC20 public uSDeToken;

    /**
     * @notice Constructor to initialize owner and platform address
     * @param _platformAddress platform wallet address to receive platform fees
     */
    constructor(address _platformAddress, address _sUSDeToken, address _uSDEeToken) Ownable(msg.sender) {
        platformAddress = _platformAddress;
        sUSDeToken = ISUSDE(_sUSDeToken);
        uSDeToken = IERC20(_uSDEeToken);
    }

    /**
     * @notice Function to set merkle root hash (only owner can set)
     * @param _merkleRoot merkle root hash
     */
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
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

        gifters[msg.sender].donatedAmount += _netAmount;
        gifters[msg.sender].totalShares += _gifterShares;
        gifters[msg.sender].grossDonatedAmount += _amount;

        creators[_to].totalDonation += _netAmount;
        creators[_to].claimableShares += _netShares;

        donationToken.transferFrom(msg.sender, platformAddress, _platformFees);
        donationToken.transferFrom(msg.sender, address(this), _netAmount);
        donationToken.approve(address(sUSDeToken), _netAmount);
        sUSDeToken.deposit(_netAmount, address(this));

        emit NewDonation(msg.sender, _amount, _netAmount, _to, _gifterShares, block.timestamp);
    }

    /**
     * @notice Withdraw function to withdraw donation from creator
     * @param _shares Amount of token to withdraw
     */
    function initiateWithdraw(uint256 _shares) external {
        if (_shares == 0) revert DONATE__AMOUNT_ZERO();
        if (creators[msg.sender].claimableShares < _shares) revert DONATE__INSUFFICIENT_BALANCE(msg.sender);

        batchWithdrawAmount += _shares;

        emit InitiateWithdraw(msg.sender, _shares, block.timestamp);
    }

    /**
     * @notice Function to batch withdraw all donation token from contract
     */
    function batchWithdraw() external onlyOwner {
        if (batchWithdrawAmount < batchWithdrawMin) {
            revert DONATE__BATCH_WITHDRAW_MINIMUM_NOT_REACHED(batchWithdrawAmount);
        }

        sUSDeToken.approve(address(sUSDeToken), batchWithdrawAmount);
        sUSDeToken.cooldownShares(batchWithdrawAmount);
        lastBatchWithdraw = block.timestamp;
    }

    /**
     * @notice Function to unstake and withdraw all donation token from contract
     */
    function unstakeBatchWithdraw() external onlyOwner {
        sUSDeToken.unstake(address(this));
    }

    /**
     * @notice Function to add allowed donation token
     * @param _token token contract address
     */
    function addAllowedDonationToken(address _token) external onlyOwner {
        allowedDonationToken[_token] = true;
        allowedDonationTokens.push(_token);

        emit addAllowedDonationTokenEvent(_token, block.timestamp);
    }

    /**
     * @notice Function to change owner of the contract
     * @param _newOwner new owner address
     */
    function changeOwner(address _newOwner) external onlyOwner {
        Ownable.transferOwnership(_newOwner);
    }

    /**
     * @notice Function to remove allowed donation token
     * @param _token token contract address
     */
    function removeAllowedDonationToken(address _token) external onlyOwner {
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

        emit removeAllowedDonationTokenEvent(_token, block.timestamp);
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
        uint256 _yield = (_totalUSDE - gifters[_user].donatedAmount);
        return _yield;
    }

    /**
     * @notice function to update SUSDE token address
     * @param _sUSDeToken sUSDe token address
     */
    function updateToken(address _sUSDeToken, address _USDeToken) external onlyOwner {
        sUSDeToken = ISUSDE(_sUSDeToken);
        uSDeToken = IERC20(_USDeToken);
    }

    /**
     * @notice function to claim token
     * @param _amount amount to claim
     * @param _proof merkle proof
     */
    function claim(uint256 _amount, bytes32[] calldata _proof) external {
        bool isValidProof = MerkleProof.verify(_proof, merkleRoot, keccak256(abi.encodePacked(msg.sender, _amount)));
        if (!isValidProof) revert DONATE__INVALID_MERKLE_PROOF();
        uSDeToken.transfer(msg.sender, _amount);
        emit ClaimReward(msg.sender, _amount, block.timestamp);
    }
}
