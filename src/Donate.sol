// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IVault.sol";

abstract contract Donate is IVault {
    struct DonationRecord {
        address to;
        uint256 amount;
    }

    struct Donatur {
        address donatur;
        uint256 amount;
    }

    uint256 public totalDonations;
    uint256 public totalWithdraw;
    address public owner;
    address public platformAddress = 0x888Ac27D8075633ab7eC60a8a309614456bC5301;

    // Platform Fees was fixed to 1% of the donation amount
    uint256 public platformFees = 1e16;
    // Goes to vault percentage fixed to 24% of the donation amount
    uint256 public vaultPercentage = 24e16;

    event Donation(address indexed donor, uint256 amount);
    event ClaimDonation(address indexed donor, uint256 amount);
    event addAllowedDonationTokenEvent(address indexed token);
    event removeAllowedDonationTokenEvent(address indexed token);

    mapping(address => uint256) public donations;
    mapping(address => DonationRecord[]) public donatedAmount;
    mapping(address => Donatur[]) public donatur;
    mapping(address => bool) public allowedDonationToken;
    address[] public allowedDonationTokens;
    address public vaultContract;

    constructor() {
        owner = msg.sender;
    }

    function donate(uint256 _amount, address _to, address _token) public {
        require(allowedDonationToken[_token], "Donate: token not allowed");
        require(_amount > 0, "Donate: amount must be greater than 0");
        require(IERC20(_token).transferFrom(msg.sender, address(this), _amount), "Donate: transfer failed");

        DonationRecord memory _donationRecord = DonationRecord({to: _to, amount: _amount});
        Donatur memory _donatur = Donatur({donatur: msg.sender, amount: _amount});

        donatedAmount[msg.sender].push(_donationRecord);
        donatur[_to].push(_donatur);

        donations[_to] += _amount;
        totalDonations += _amount;

        emit Donation(msg.sender, _amount);
    }

    function claimDonation(uint256 _amount, address _token) public {
        require(allowedDonationToken[_token], "Donate: token not allowed");
        require(donations[msg.sender] >= _amount, "Donate: not enough balance");

        // calculate platform fees and donation amount
        uint256 _platformFees = (_amount * platformFees) / 1e18;
        uint256 _vaultAmount = (_amount * vaultPercentage) / 1e18;
        uint256 _donationAmount = _amount - _platformFees - _vaultAmount;

        // 75% of the donation amount goes to the user
        require(IERC20(_token).transfer(msg.sender, _donationAmount), "Donate: donation transfer failed");

        // 1% of the donation amount goes to the platform
        require(IERC20(_token).transfer(platformAddress, _platformFees), "Donate: fees transfer failed");

        // 24% of the donation amount goes to the vault
        require(IERC20(_token).approve(vaultContract, _vaultAmount), "Donate: approve failed");
        require(IVault(vaultContract).depositToVault(msg.sender, _vaultAmount, _token), "Donate: deposit failed");

        donations[msg.sender] -= _amount;
        totalWithdraw += _amount;

        emit ClaimDonation(msg.sender, _amount);
    }

    function getTotalDonations(address _user) public view returns (uint256) {
        return donatur[_user].length;
    }

    function getDonaturData(address _user, uint256 _index) public view returns (address, uint256) {
        return (donatur[_user][_index].donatur, donatur[_user][_index].amount);
    }

    function addAllowedDonationToken(address _token) public {
        require(msg.sender == owner, "Donate: only owner can add token");
        allowedDonationToken[_token] = true;
        allowedDonationTokens.push(_token);

        emit addAllowedDonationTokenEvent(_token);
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner, "Donate: only owner can change owner");
        owner = _newOwner;
    }

    function removeAllowedDonationToken(address _token) public {
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

    function isTokenAllowed(address _token) public view returns (bool) {
        return allowedDonationToken[_token];
    }

    function isActiveUser(address _user) public view returns (bool) {
        // Active user determine based on the donation amount or the number of donations
        return donations[_user] > 0 || donatur[_user].length > 0;
    }

    function updateVaultContract(address _vaultContract) public {
        require(msg.sender == owner, "Donate: only owner can update vault contract");
        vaultContract = _vaultContract;
    }
}
