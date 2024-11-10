# IMockUSDE
[Git Source](https://github.com/onekill0503/donate-sc/blob/a078220bd4d81597f10b7d396efe342f73180a17/src\interfaces\IMockUSDE.sol)


## Functions
### mintUSDEFromVault

mint USDE and this function should called from vault contract


```solidity
function mintUSDEFromVault(address to, uint256 amount) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|wallet address to receive minted USDE|
|`amount`|`uint256`|amount of USDE to mint|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of mint process|


### burnUSDEFromVault

burn USDE and this function should called from vault contract


```solidity
function burnUSDEFromVault(uint256 amount) external returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|amount of USDE to burn|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|status status of burn process|


