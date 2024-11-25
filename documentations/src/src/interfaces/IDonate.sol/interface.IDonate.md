# IDonate
[Git Source](https://github.com/onekill0503/donate-sc/blob/c651947d75ba95d6ea162a0584ab79c01ebd96d1/src\interfaces\IDonate.sol)


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


### updateDonatedAmount

function to update donate record at Donate smartcontract


```solidity
function updateDonatedAmount(address _user, uint256 _index, uint256 _claimed, uint256 _lockedDonaturYield) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|donatur wallet address|
|`_index`|`uint256`|index of Donatur Record array|
|`_claimed`|`uint256`|amount claimed token by creator|
|`_lockedDonaturYield`|`uint256`|donatur yield locked amount|


