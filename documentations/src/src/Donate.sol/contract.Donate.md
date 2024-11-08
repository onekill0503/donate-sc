# Donate
[Git Source](https://github.com/onekill0503/donate-sc/blob/b586165cee99e3057a977a781c8c80d9f666681c/src\Donate.sol)

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


### owner
Variables to store owner address


```solidity
address public owner;
```


### platformAddress
Variables to store platform address


```solidity
address public platformAddress;
```


### platformFees
Platform Fees Percentage (fixed to 5%), platform fees will be deducted when user donate


```solidity
uint256 public platformFees = 5e16;
```


### creatorPercentage
creator Fees Percentage (fixed to 30%), creator fees will be deducted when creator claim donation


```solidity
uint256 public creatorPercentage = 30e16;
```


### yieldPercentage
yield Percentage (fixed to 75%), this is donatur yield percentage for cashback


```solidity
uint256 public yieldPercentage = 75e16;
```


### donations
Donation Mapping to store donation data


```solidity
mapping(address => mapping(address => uint256)) public donations;
```


### donatedAmount
Donated Record for each donatur based on donatur wallet address as a key


```solidity
mapping(address => DonationRecord[]) public donatedAmount;
```


### donatur
Donatur Mapping to store donatur data based creator address as a key


```solidity
mapping(address => Donatur[]) public donatur;
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


### vaultContract
Vault Contract Address


```solidity
address public vaultContract;
```


## Functions
### constructor

Constructor to initialize owner and platform address


```solidity
constructor(address _platformAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_platformAddress`|`address`|platform wallet address to receive platform fees|


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


### withdraw

Withdraw function to withdraw donation from creator


```solidity
function withdraw(uint256 _amount, address _token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|Amount of token to withdraw|
|`_token`|`address`|token contract address to withdraw|


### getTotalDonations

get total creator donation based on creator wallet address


```solidity
function getTotalDonations(address _user) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|creator address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|length total donation record data count|


### getDonaturData

get Donatur Data based on creator wallet address and index of donatur array


```solidity
function getDonaturData(address _user, uint256 _index) external view returns (address, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|creator wallet address|
|`_index`|`uint256`|index of donatur array|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|_donatur donatur wallet address|
|`<none>`|`uint256`|_amount donation amount|


### addAllowedDonationToken

Function to add allowed donation token


```solidity
function addAllowedDonationToken(address _token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|token contract address|


### changeOwner

Function to change owner of the contract


```solidity
function changeOwner(address _newOwner) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newOwner`|`address`|new owner address|


### removeAllowedDonationToken

Function to remove allowed donation token


```solidity
function removeAllowedDonationToken(address _token) external;
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


### isActiveUser

function to check is user an active user or not


```solidity
function isActiveUser(address _user) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|user wallet address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of user is active or not|


### updateVaultContract

function to update vault contract address


```solidity
function updateVaultContract(address _vaultContract) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_vaultContract`|`address`|new vault contract address|


### updateTotalWithdrawFromVault

function to update total withdraw amount from vault


```solidity
function updateTotalWithdrawFromVault(uint256 _amount) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|amount of token to update|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of update total withdraw|


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


## Events
### Donation

```solidity
event Donation(address indexed donor, uint256 amount);
```

### WithdrawDonation

```solidity
event WithdrawDonation(address indexed donor, uint256 amount);
```

### addAllowedDonationTokenEvent

```solidity
event addAllowedDonationTokenEvent(address indexed token);
```

### removeAllowedDonationTokenEvent

```solidity
event removeAllowedDonationTokenEvent(address indexed token);
```

## Structs
### DonationRecord
Donation Record Struct to record donation data


```solidity
struct DonationRecord {
    address to;
    uint256 amount;
    address token;
    uint256 vaultIndex;
    uint256 claimed;
    uint256 grossAmount;
}
```

### Donatur
Donatur Struct to record donatur data


```solidity
struct Donatur {
    address donatur;
    uint256 amount;
    address token;
}
```

