// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IVault.sol";

contract Donate {
    struct DonationRecord {
        address to;
        uint256 amount;
        address token;
        uint256 vaultIndex;
        uint256 claimed;
        uint256 grossAmount;
    }

    struct Donatur {
        address donatur;
        uint256 amount;
        address token;
    }

    uint256 public totalDonations;
    uint256 public totalWithdraw;
    address public owner;
    address public platformAddress;

    // Platform Fees was fixed to 1% of the donation amount goes to platform after donation
    uint256 public platformFees = 5e16;
    // Goes to vault percentage fixed to 30% of the donation amount
    uint256 public creatorPercentage = 30e16;
    // Goes to yield percentage fixed to 75% of the donation amount
    uint256 public yieldPercentage = 75e16;

    event Donation(address indexed donor, uint256 amount);
    event WithdrawDonation(address indexed donor, uint256 amount);
    event addAllowedDonationTokenEvent(address indexed token);
    event removeAllowedDonationTokenEvent(address indexed token);

    mapping(address => mapping(address => uint256)) public donations;
    mapping(address => DonationRecord[]) public donatedAmount;
    mapping(address => Donatur[]) public donatur;
    mapping(address => bool) public allowedDonationToken;
    address[] public allowedDonationTokens;
    address public vaultContract;

    constructor(address _platformAddress) {
        owner = msg.sender;
        platformAddress = _platformAddress;
    }

    function donate(uint256 _amount, address _to, address _token) external {
        require(allowedDonationToken[_token], "Donate: token not allowed");
        require(_amount > 0, "Donate: amount must be greater than 0");

        uint256 _vaultIndex =
            IVault(vaultContract).depositToVault(_to, msg.sender, _amount, _token, donatedAmount[msg.sender].length);
        require(_vaultIndex > 0, "Donate: deposit failed");

        // Calculate the net amount ( amount - platform fees )
        uint256 _platformAmount = (_amount * platformFees / 1e18);
        uint256 _netAmount = _amount - _platformAmount;
        DonationRecord memory _donationRecord = DonationRecord({
            to: _to,
            amount: _netAmount,
            token: _token,
            vaultIndex: _vaultIndex,
            claimed: 0,
            grossAmount: _amount
        });
        Donatur memory _donatur = Donatur({donatur: msg.sender, amount: _netAmount, token: _token});

        donatedAmount[msg.sender].push(_donationRecord);
        donatur[_to].push(_donatur);

        donations[_to][_token] += _amount;
        totalDonations += _amount;

        emit Donation(msg.sender, _amount);
    }

    function withdraw(uint256 _amount, address _token) external {
        require(allowedDonationToken[_token], "Donate: token not allowed");

        IVault(vaultContract).withdrawFromVault(msg.sender, _amount, _token);

        totalWithdraw += _amount;
        emit WithdrawDonation(msg.sender, _amount);
    }

    function getTotalDonations(address _user) external view returns (uint256) {
        return donatur[_user].length;
    }

    function getDonaturData(address _user, uint256 _index) external view returns (address, uint256) {
        return (donatur[_user][_index].donatur, donatur[_user][_index].amount);
    }

    function addAllowedDonationToken(address _token) external {
        require(msg.sender == owner, "Donate: only owner can add token");
        allowedDonationToken[_token] = true;
        allowedDonationTokens.push(_token);

        emit addAllowedDonationTokenEvent(_token);
    }

    function changeOwner(address _newOwner) external {
        require(msg.sender == owner, "Donate: only owner can change owner");
        owner = _newOwner;
    }

    function removeAllowedDonationToken(address _token) external {
        require(msg.sender == owner, "Donate: only owner can remove token");
        allowedDonationToken[_token] = false;

        // Get the index of the token to be removed
        uint256 _removedIndex = allowedDonationTokens.length;
        for (uint256 i = 0; i < allowedDonationTokens.length; i++) {
            if (allowedDonationTokens[i] == _token) {
                _removedIndex = i;
                break;
            }
        }

        // if the token is not found, revert
        require(_removedIndex < allowedDonationTokens.length, "Donate: token not found");

        // Move the last element to the removed index
        for (uint256 i = _removedIndex; i < allowedDonationTokens.length - 1; i++) {
            allowedDonationTokens[i] = allowedDonationTokens[i + 1];
        }

        // Pop the last element
        allowedDonationTokens.pop();

        emit removeAllowedDonationTokenEvent(_token);
    }

    function isTokenAllowed(address _token) external view returns (bool) {
        return allowedDonationToken[_token];
    }

    function isActiveUser(address _user) external view returns (bool) {
        require(msg.sender == vaultContract, "Donate: only vault contract can check active user");
        return donatur[_user].length > 0;
    }

    function updateVaultContract(address _vaultContract) external {
        require(msg.sender == owner, "Donate: only owner can update vault contract");
        vaultContract = _vaultContract;
    }

    function updateTotalWithdrawFromVault(uint256 _amount) external returns (bool) {
        require(msg.sender == vaultContract, "Donate: only vault contract can update total withdraw");
        totalWithdraw += _amount;
        return true;
    }

    function getYield(address _user) external view returns (uint256) {
        uint256 _yield = 0;
        uint256 _yieldFromVault = 0;
        for (uint256 i = donatedAmount[_user].length - 1; i >= 0; i--) {
            if (donatedAmount[_user][i].claimed == donatedAmount[_user][i].amount) break;
            _yieldFromVault += IVault(vaultContract).getYieldByIndex(_user, donatedAmount[_user][i].vaultIndex);
            uint256 _unClaimedPercentage = (donatedAmount[_user][i].amount - donatedAmount[_user][i].claimed) * 1e18
                / donatedAmount[_user][i].amount;
            _yield += _yieldFromVault * _unClaimedPercentage / 1e18;
        }
        // return percentage of yield
        return _yield * yieldPercentage / 1e18;
    }
}
