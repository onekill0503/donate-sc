# IVault
[Git Source](https://github.com/onekill0503/donate-sc/blob/b586165cee99e3057a977a781c8c80d9f666681c/src\interfaces\IVault.sol)


## Functions
### depositToVault

function to deposit token to vault


```solidity
function depositToVault(address _to, address _from, uint256 _amount, address _tokenAddress, uint256 _donateRecordIndex)
    external
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_to`|`address`|creator wallet address|
|`_from`|`address`|donatur wallet address|
|`_amount`|`uint256`|donate amount|
|`_tokenAddress`|`address`|donated token address|
|`_donateRecordIndex`|`uint256`|index of donate record array|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|index return index of locked tokens array|


### getYieldByIndex

function to get creator yield by locked token index array


```solidity
function getYieldByIndex(address _user, uint256 _index) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|creator wallet address|
|`_index`|`uint256`|locked token index array|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|yield creator yield|


### withdrawFromVault

function to withdraw creator donation include creator yield


```solidity
function withdrawFromVault(address _to, uint256 _amount, address _token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_to`|`address`|creator wallet address to receive token|
|`_amount`|`uint256`|amount to withdraw|
|`_token`|`address`|token contract address|


