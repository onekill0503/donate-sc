# ISUSDE
[Git Source](https://github.com/onekill0503/donate-sc/blob/c651947d75ba95d6ea162a0584ab79c01ebd96d1/src\interfaces\ISUSDE.sol)


## Functions
### DEFAULT_ADMIN_ROLE


```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
```

### DOMAIN_SEPARATOR


```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32);
```

### MAX_COOLDOWN_DURATION


```solidity
function MAX_COOLDOWN_DURATION() external view returns (uint24);
```

### acceptAdmin


```solidity
function acceptAdmin() external;
```

### addToBlacklist


```solidity
function addToBlacklist(address target, bool isFullBlacklisting) external;
```

### allowance


```solidity
function allowance(address owner, address spender) external view returns (uint256);
```

### approve


```solidity
function approve(address spender, uint256 amount) external returns (bool);
```

### asset


```solidity
function asset() external view returns (address);
```

### balanceOf


```solidity
function balanceOf(address account) external view returns (uint256);
```

### convertToAssets


```solidity
function convertToAssets(uint256 shares) external view returns (uint256);
```

### convertToShares


```solidity
function convertToShares(uint256 assets) external view returns (uint256);
```

### cooldownAssets


```solidity
function cooldownAssets(uint256 assets) external returns (uint256 shares);
```

### cooldownDuration


```solidity
function cooldownDuration() external view returns (uint24);
```

### cooldownShares


```solidity
function cooldownShares(uint256 shares) external returns (uint256 assets);
```

### cooldowns


```solidity
function cooldowns(address) external view returns (uint104 cooldownEnd, uint152 underlyingAmount);
```

### decimals


```solidity
function decimals() external pure returns (uint8);
```

### decreaseAllowance


```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
```

### deposit


```solidity
function deposit(uint256 assets, address receiver) external returns (uint256);
```

### eip712Domain


```solidity
function eip712Domain()
    external
    view
    returns (
        bytes1 fields,
        string memory name,
        string memory version,
        uint256 chainId,
        address verifyingContract,
        bytes32 salt,
        uint256[] memory extensions
    );
```

### getRoleAdmin


```solidity
function getRoleAdmin(bytes32 role) external view returns (bytes32);
```

### getUnvestedAmount


```solidity
function getUnvestedAmount() external view returns (uint256);
```

### grantRole


```solidity
function grantRole(bytes32 role, address account) external;
```

### hasRole


```solidity
function hasRole(bytes32 role, address account) external view returns (bool);
```

### increaseAllowance


```solidity
function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
```

### lastDistributionTimestamp


```solidity
function lastDistributionTimestamp() external view returns (uint256);
```

### maxDeposit


```solidity
function maxDeposit(address) external view returns (uint256);
```

### maxMint


```solidity
function maxMint(address) external view returns (uint256);
```

### maxRedeem


```solidity
function maxRedeem(address owner) external view returns (uint256);
```

### maxWithdraw


```solidity
function maxWithdraw(address owner) external view returns (uint256);
```

### mint


```solidity
function mint(uint256 shares, address receiver) external returns (uint256);
```

### name


```solidity
function name() external view returns (string memory);
```

### nonces


```solidity
function nonces(address owner) external view returns (uint256);
```

### owner


```solidity
function owner() external view returns (address);
```

### permit


```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
    external;
```

### previewDeposit


```solidity
function previewDeposit(uint256 assets) external view returns (uint256);
```

### previewMint


```solidity
function previewMint(uint256 shares) external view returns (uint256);
```

### previewRedeem


```solidity
function previewRedeem(uint256 shares) external view returns (uint256);
```

### previewWithdraw


```solidity
function previewWithdraw(uint256 assets) external view returns (uint256);
```

### redeem


```solidity
function redeem(uint256 shares, address receiver, address _owner) external returns (uint256);
```

### redistributeLockedAmount


```solidity
function redistributeLockedAmount(address from, address to) external;
```

### removeFromBlacklist


```solidity
function removeFromBlacklist(address target, bool isFullBlacklisting) external;
```

### renounceRole


```solidity
function renounceRole(bytes32, address) external;
```

### rescueTokens


```solidity
function rescueTokens(address token, uint256 amount, address to) external;
```

### revokeRole


```solidity
function revokeRole(bytes32 role, address account) external;
```

### setCooldownDuration


```solidity
function setCooldownDuration(uint24 duration) external;
```

### silo


```solidity
function silo() external view returns (address);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool);
```

### symbol


```solidity
function symbol() external view returns (string memory);
```

### totalAssets


```solidity
function totalAssets() external view returns (uint256);
```

### totalSupply


```solidity
function totalSupply() external view returns (uint256);
```

### transfer


```solidity
function transfer(address to, uint256 amount) external returns (bool);
```

### transferAdmin


```solidity
function transferAdmin(address newAdmin) external;
```

### transferFrom


```solidity
function transferFrom(address from, address to, uint256 amount) external returns (bool);
```

### transferInRewards


```solidity
function transferInRewards(uint256 amount) external;
```

### unstake


```solidity
function unstake(address receiver) external;
```

### vestingAmount


```solidity
function vestingAmount() external view returns (uint256);
```

### withdraw


```solidity
function withdraw(uint256 assets, address receiver, address _owner) external returns (uint256);
```

## Events
### AdminTransferRequested

```solidity
event AdminTransferRequested(address indexed oldAdmin, address indexed newAdmin);
```

### AdminTransferred

```solidity
event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);
```

### Approval

```solidity
event Approval(address indexed owner, address indexed spender, uint256 value);
```

### CooldownDurationUpdated

```solidity
event CooldownDurationUpdated(uint24 previousDuration, uint24 newDuration);
```

### Deposit

```solidity
event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
```

### EIP712DomainChanged

```solidity
event EIP712DomainChanged();
```

### LockedAmountRedistributed

```solidity
event LockedAmountRedistributed(address indexed from, address indexed to, uint256 amount);
```

### RewardsReceived

```solidity
event RewardsReceived(uint256 amount);
```

### RoleAdminChanged

```solidity
event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
```

### RoleGranted

```solidity
event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
```

### RoleRevoked

```solidity
event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
```

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 value);
```

### Withdraw

```solidity
event Withdraw(address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares);
```

## Errors
### CantBlacklistOwner

```solidity
error CantBlacklistOwner();
```

### ExcessiveRedeemAmount

```solidity
error ExcessiveRedeemAmount();
```

### ExcessiveWithdrawAmount

```solidity
error ExcessiveWithdrawAmount();
```

### InvalidAdminChange

```solidity
error InvalidAdminChange();
```

### InvalidAmount

```solidity
error InvalidAmount();
```

### InvalidCooldown

```solidity
error InvalidCooldown();
```

### InvalidShortString

```solidity
error InvalidShortString();
```

### InvalidToken

```solidity
error InvalidToken();
```

### InvalidZeroAddress

```solidity
error InvalidZeroAddress();
```

### MinSharesViolation

```solidity
error MinSharesViolation();
```

### NotPendingAdmin

```solidity
error NotPendingAdmin();
```

### OperationNotAllowed

```solidity
error OperationNotAllowed();
```

### StillVesting

```solidity
error StillVesting();
```

### StringTooLong

```solidity
error StringTooLong(string str);
```

