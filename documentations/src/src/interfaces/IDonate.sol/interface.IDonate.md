# IDonate
[Git Source](https://github.com/onekill0503/donate-sc/blob/b586165cee99e3057a977a781c8c80d9f666681c/src\interfaces\IDonate.sol)


## Functions
### isActiveUser

function to check is user active or not


```solidity
function isActiveUser(address _user) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|user address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status user status|


### isTokenAllowed

function to check is token allowed or not


```solidity
function isTokenAllowed(address _token) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|token address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status token status|


### updateTotalWidthdrawFromVault

function to update total withdraw amount from vault


```solidity
function updateTotalWidthdrawFromVault(uint256 _amount) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|amount of token to update|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of update total withdraw|


### creatorPercentage

function to get percentage of creator yield portion


```solidity
function creatorPercentage() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|creatorPercentage creator yield percentage|


### yieldPercentage

function to get percentage of donatur yield portion


```solidity
function yieldPercentage() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|donaturPercentage donatur yield percentage|


