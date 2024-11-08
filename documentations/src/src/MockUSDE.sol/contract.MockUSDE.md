# MockUSDE
[Git Source](https://github.com/onekill0503/donate-sc/blob/b586165cee99e3057a977a781c8c80d9f666681c/src\MockUSDE.sol)

**Inherits:**
ERC20, ERC20Burnable, Ownable, ERC20Permit


## State Variables
### vaultContract
vault contract address


```solidity
address public vaultContract;
```


## Functions
### constructor

constructor to create USDE token


```solidity
constructor(address initialOwner) ERC20("MockUSDE", "MUSDE") Ownable(initialOwner) ERC20Permit("MockUSDE");
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`initialOwner`|`address`|initial owner of contract|


### mint

function to mint USDE ( only owner of contract can call this function )


```solidity
function mint(address to, uint256 amount) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|wallet address to receive minted USDE|
|`amount`|`uint256`|amount of USDE to mint|


### updateVault

update vault contract address ( only owner of contract can call this function )


```solidity
function updateVault(address _vaultContract) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_vaultContract`|`address`|new vault contract address|


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


