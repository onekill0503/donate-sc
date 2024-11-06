// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Donate {

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
    

    event Donation(address indexed donor, uint256 amount);
    event ClaimDonation(address indexed donor, uint256 amount);
    event addAllowedDonationTokenEvent(address indexed token);
    event removeAllowedDonationTokenEvent(address indexed token);

    mapping(address => uint256) public donations;
    mapping(address => DonationRecord[]) public donatedAmount;
    mapping(address => Donatur[]) public donatur;
    mapping(address => bool) public allowedDonationToken;
    address[] public allowedDonationTokens;

    constructor() {
        owner = msg.sender;
    }

    function donate(uint256 _amount, address _to, address _token) public {
        require(allowedDonationToken[_token], "Donate: token not allowed");
        require(_amount > 0, "Donate: amount must be greater than 0");
        require(IERC20(_token).transferFrom(msg.sender, address(this), _amount), "Donate: transfer failed");

        DonationRecord memory _donationRecord = DonationRecord({ to: _to, amount: _amount });
        Donatur memory _donatur = Donatur({ donatur: msg.sender, amount: _amount });

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
        uint256 _donationAmount = _amount - _platformFees;

        require(IERC20(_token).transfer(msg.sender, _donationAmount), "Donate: transfer failed");

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

}