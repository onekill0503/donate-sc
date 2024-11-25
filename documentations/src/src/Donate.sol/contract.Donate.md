# Donate
[Git Source](https://github.com/onekill0503/donate-sc/blob/c651947d75ba95d6ea162a0584ab79c01ebd96d1/src\Donate.sol)

**Inherits:**
Ownable

**Author:**
To De Moon Team

This Contract is used for donation and store the donation data

**Note:**
This is an experimental contract


## State Variables
### totalDonations
Variables to store total donations


```solidity
uint256 public totalDonations;
```


### totalWithdraw
Variables to store total withdraw


```solidity
uint256 public totalWithdraw;
```


### platformAddress
Variables to store platform address


```solidity
address public platformAddress;
```


### platformFees
Platform Fees Percentage (fixed to 5%), platform fees will be deducted when user donate


```solidity
uint256 public platformFees = 5;
```


### creatorPercentage
creator Fees Percentage (fixed to 30%), creator fees will be deducted when creator claim donation


```solidity
uint256 public creatorPercentage = 30;
```


### gifterPercentage
yield Percentage (fixed to 70%), this is donatur yield percentage for cashback


```solidity
uint256 public gifterPercentage = 70;
```


### batchWithdrawAmount
batchWithdrawAmount to store total amount to batch withdraw


```solidity
uint256 public batchWithdrawAmount = 0;
```


### batchWithdrawMin
batchWithdrawMin to store minimum amount to batch withdraw


```solidity
uint256 public batchWithdrawMin = 500e18;
```


### merkleRoot
Merkle Root Hash to store merkle root hash


```solidity
bytes32 public merkleRoot;
```


### gifters
Donation Mapping to store donation data


```solidity
mapping(address => GiftersRecord) public gifters;
```


### creators

```solidity
mapping(address => CreatorsRecord) public creators;
```


### allowedDonationToken
Allowed Donation Token Mapping to store allowed donation token


```solidity
mapping(address => bool) public allowedDonationToken;
```


### allowedDonationTokens
Allowed Donation Token Array to store allowed donation token


```solidity
address[] public allowedDonationTokens;
```


### sUSDeToken
sUSDe token address with ISUSDE interface


```solidity
ISUSDE public sUSDeToken;
```


### uSDeToken
USDe token address with IERC20 interface


```solidity
IERC20 public uSDeToken;
```


## Functions
### constructor

Constructor to initialize owner and platform address


```solidity
constructor(address _platformAddress, address _sUSDeToken) Ownable(msg.sender);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_platformAddress`|`address`|platform wallet address to receive platform fees|
|`_sUSDeToken`|`address`||


### setMerkleRoot

Function to set merkle root hash (only owner can set)


```solidity
function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_merkleRoot`|`bytes32`|merkle root hash|


### donate

Donate function to donate token to creator


```solidity
function donate(uint256 _amount, address _to, address _token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|Donation amount for creator|
|`_to`|`address`|Creator wallet address|
|`_token`|`address`|donation token address (ex: USDe)|


### initiateWithdraw

Withdraw function to withdraw donation from creator


```solidity
function initiateWithdraw(uint256 _shares) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_shares`|`uint256`|Amount of token to withdraw|


### batchWithdraw

Function to batch withdraw all donation token from contract


```solidity
function batchWithdraw() external onlyOwner;
```

### unstakeBatchWithdraw

Function to unstake and withdraw all donation token from contract


```solidity
function unstakeBatchWithdraw() external onlyOwner;
```

### addAllowedDonationToken

Function to add allowed donation token


```solidity
function addAllowedDonationToken(address _token) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|token contract address|


### changeOwner

Function to change owner of the contract


```solidity
function changeOwner(address _newOwner) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newOwner`|`address`|new owner address|


### removeAllowedDonationToken

Function to remove allowed donation token


```solidity
function removeAllowedDonationToken(address _token) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|token contract address|


### isTokenAllowed

function to check is token allowed for donation or not


```solidity
function isTokenAllowed(address _token) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|token contract address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of token is allowed or not|


### getYield

function to get yield amount from active donation user


```solidity
function getYield(address _user) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|user wallet address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|_yield yield amount deducted by yeild percentage|


### updateToken

function to update SUSDE token address


```solidity
function updateToken(address _sUSDeToken, address _USDeToken) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_sUSDeToken`|`address`|sUSDe token address|
|`_USDeToken`|`address`||


### claim

function to claim token


```solidity
function claim(uint256 _amount, bytes32[] calldata _proof) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|amount to claim|
|`_proof`|`bytes32[]`|merkle proof|


## Events
### NewDonation

```solidity
event NewDonation(
    address indexed gifter, uint256 grossAmount, uint256 netAmount, address indexed creator, uint256 gifterShares
);
```

### InitiateWithdraw

```solidity
event InitiateWithdraw(address indexed creator, uint256 shares);
```

### addAllowedDonationTokenEvent

```solidity
event addAllowedDonationTokenEvent(address indexed token);
```

### removeAllowedDonationTokenEvent

```solidity
event removeAllowedDonationTokenEvent(address indexed token);
```

## Errors
### DONATE__NOT_ALLOWED_TOKEN

```solidity
error DONATE__NOT_ALLOWED_TOKEN(address token);
```

### DONATE__AMOUNT_ZERO

```solidity
error DONATE__AMOUNT_ZERO();
```

### DONATE__INSUFFICIENT_BALANCE

```solidity
error DONATE__INSUFFICIENT_BALANCE(address wallet);
```

### DONATE__WALLET_NOT_ALLOWED

```solidity
error DONATE__WALLET_NOT_ALLOWED(address wallet);
```

### DONATE__BATCH_WITHDRAW_MINIMUM_NOT_REACHED

```solidity
error DONATE__BATCH_WITHDRAW_MINIMUM_NOT_REACHED(uint256 batchWithdrawAmount);
```

### DONATE__INVALID_MERKLE_PROOF

```solidity
error DONATE__INVALID_MERKLE_PROOF();
```

## Structs
### GiftersRecord
Gifters Record Struct to Gifter data


```solidity
struct GiftersRecord {
    uint256 donatedAmount;
    uint256 totalShares;
    uint256 grossDonatedAmount;
}
```

### CreatorsRecord
Creators Record Struct to Creator data


```solidity
struct CreatorsRecord {
    uint256 totalDonation;
    uint256 claimableShares;
}
```

