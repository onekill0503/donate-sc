# IMockSUSDE
[Git Source](https://github.com/onekill0503/donate-sc/blob/b586165cee99e3057a977a781c8c80d9f666681c/src\interfaces\IMockSUSDE.sol)


## Functions
### mintSUSDEFromVault

mint SUSDE and this function should called from vault contract


```solidity
function mintSUSDEFromVault(address to, uint256 amount) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|wallet address to receive minted SUSDE|
|`amount`|`uint256`|amount of SUSDE to mint|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of mint process|


### burnSUSDEFromVault

burn SUSDE and this function should called from vault contract


```solidity
function burnSUSDEFromVault(uint256 amount) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|amount of SUSDE to burn|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of burn process|


