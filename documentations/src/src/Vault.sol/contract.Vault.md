# Vault
[Git Source](https://github.com/onekill0503/donate-sc/blob/b586165cee99e3057a977a781c8c80d9f666681c/src\Vault.sol)

**Author:**
To De Moon Team

This contract is used to store locked token and yield then distribute to creator and donatur

**Note:**
This is an experimental contract


## State Variables
### owner
owner of the contract


```solidity
address public owner;
```


### vaultToken
vault token address


```solidity
address public vaultToken;
```


### donateContract
donate contract address


```solidity
address public donateContract;
```


### totalLockBlocks
total lock blocks for 1 month


```solidity
uint256 public totalLockBlocks;
```


### mockedExchangeRate
exchange rate for 1 USDe to sUSDe


```solidity
uint256 public mockedExchangeRate = 98e16;
```


### lockedTokens
locked token mapping


```solidity
mapping(address => LockedToken[]) public lockedTokens;
```


## Functions
### constructor

constructor to create Vault contract


```solidity
constructor(address _vaultToken, address _donateContract);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_vaultToken`|`address`|contract address of token for vault token (yield token , ex: sUSDe)|
|`_donateContract`|`address`|donation contract address|


### changeOwner

this function is used to change owner of the contract


```solidity
function changeOwner(address _newOwner) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newOwner`|`address`|new owner address|


### withdrawFromVault

this function is used to withdraw token from vault to creator


```solidity
function withdrawFromVault(address _to, uint256 _amount, address _token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_to`|`address`|Wallet Address who receive donation|
|`_amount`|`uint256`|Amount of Token (name token based on _token) to Withdraw (include yield)|
|`_token`|`address`|Token Contract address for output|


### depositToVault

this function is used to deposit token to vault


```solidity
function depositToVault(address _to, address _from, uint256 _amount, address _tokenAddress, uint256 _donateRecordIndex)
    external
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_to`|`address`|Creator Wallet Address who receive donation|
|`_from`|`address`|Donatur Wallet Address who send donation|
|`_amount`|`uint256`|Donate Amount in USDe|
|`_tokenAddress`|`address`|Token Address for donation|
|`_donateRecordIndex`|`uint256`|Array Index for Donation Record at Donate Contract|


### updateVault

this function is used to update vault token and donation contract address


```solidity
function updateVault(address _token, address _donateContract) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|contract address of token for vault token (yield token , ex: sUSDe)|
|`_donateContract`|`address`|donation contract address|


### getCreatorTokens

this function is used to get creator locked and unlocked token


```solidity
function getCreatorTokens(address _creator) external view returns (uint256, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_creator`|`address`|Creator Wallet Address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|_lockedTokens return total Locked Token include locked yield|
|`<none>`|`uint256`|_unlockTokens return total Unlocked Token include unlocked yield|


### getYieldByIndex

this function is used to get yield by index of lockedTokens array


```solidity
function getYieldByIndex(address _creator, uint256 _index) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_creator`|`address`|creator address|
|`_index`|`uint256`|array index for lockedTokens|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|_yield amount of yield in specific lockedTokens index|


### updateLockBlocks

this function is used to update lock blocks for 1 month


```solidity
function updateLockBlocks(uint256 _blocks) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_blocks`|`uint256`|total lock blocks for 1 month (based on average block per day)|


### updateExchangeRate

this function is used to update exchange rate for 1 USDe to sUSDe


```solidity
function updateExchangeRate(uint256 _rate) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_rate`|`uint256`|exchange rate for 1 USDe to sUSDe (it's just mock for testing)|


## Structs
### LockedToken
Locked Token Struct


```solidity
struct LockedToken {
    address from;
    uint256 amountsUSDe;
    uint256 amountUSDe;
    uint256 exchangeRateSnapshot;
    uint256 lockUntil;
    uint256 donateRecordIndex;
    uint256 claimed;
    uint256 lockedDonaturYield;
}
```

