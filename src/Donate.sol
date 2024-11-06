// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IVault.sol";

abstract contract Donate is IVault {
    struct DonationRecord {
        address to;
        uint256 amount;
        address token;
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

    // Platform Fees was fixed to 1% of the donation amount
    uint256 public platformFees = 1e16;
    // Goes to vault percentage fixed to 24% of the donation amount
    uint256 public vaultPercentage = 24e16;

    event Donation(address indexed donor, uint256 amount);
    event ClaimDonation(address indexed donor, uint256 amount);
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

    function donate(uint256 _amount, address _to, address _token) public {
        require(allowedDonationToken[_token], "Donate: token not allowed");
        require(_amount > 0, "Donate: amount must be greater than 0");
        require(IERC20(_token).transferFrom(msg.sender, address(this), _amount), "Donate: transfer failed");

        DonationRecord memory _donationRecord = DonationRecord({to: _to, amount: _amount, token: _token});
        Donatur memory _donatur = Donatur({donatur: msg.sender, amount: _amount, token: _token});

        donatedAmount[msg.sender].push(_donationRecord);
        donatur[_to].push(_donatur);

        donations[_to][_token] += _amount;
        totalDonations += _amount;

        emit Donation(msg.sender, _amount);
    }

    function moveAllDonation(bool _claim) public {
        int256 totalFunds = 0;
        for (uint256 i = 0; i < allowedDonationTokens.length; i++) {
            if (donations[msg.sender][allowedDonationTokens[i]] == 0) continue;
            totalFunds += int256(donations[msg.sender][allowedDonationTokens[i]]);
            moveDonation(donations[msg.sender][allowedDonationTokens[i]], allowedDonationTokens[i], _claim);
        }
        require(totalFunds > 0, "Donate: no funds to move");
    }

    function moveDonation(uint256 _amount, address _token, bool _claim) public {
        require(allowedDonationToken[_token], "Donate: token not allowed");
        require(donations[msg.sender][_token] >= _amount, "Donate: not enough balance");
        uint256 _vaultPercentage = vaultPercentage;
        if (!_claim) {
            _vaultPercentage = 99e16; // 99% of the donation amount goes to the vault to getting yield
        }
        uint256 _platformFees = (_amount * platformFees) / 1e18;
        uint256 _vaultAmount = (_amount * _vaultPercentage) / 1e18;
        // calculate platform fees and donation amount

        uint256 _donationAmount = _amount - _platformFees - _vaultAmount;

        if (_donationAmount > 0) {
            // 75% of the donation amount goes to the user
            require(IERC20(_token).transfer(msg.sender, _donationAmount), "Donate: donation transfer failed");
        }

        // 1% of the donation amount goes to the platform
        require(IERC20(_token).transfer(platformAddress, _platformFees), "Donate: fees transfer failed");

        // 24% of the donation amount goes to the vault
        require(IERC20(_token).approve(vaultContract, _vaultAmount), "Donate: approve failed");
        require(IVault(vaultContract).depositToVault(msg.sender, _vaultAmount, _token), "Donate: deposit failed");

        donations[msg.sender][_token] -= _amount;
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
        return donatur[_user].length > 0;
    }

    function updateVaultContract(address _vaultContract) public {
        require(msg.sender == owner, "Donate: only owner can update vault contract");
        vaultContract = _vaultContract;
    }

    function updateTotalWithdrawFromVault(uint256 _amount) public returns (bool) {
        require(msg.sender == vaultContract, "Donate: only vault contract can update total withdraw");
        totalWithdraw += _amount;
        return true;
    }
}
