import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {console} from "forge-std/console.sol";

contract SUSDE is ERC20, ERC20Burnable, Ownable {
    using SafeERC20 for IERC20;

    uint256 public mockedRate = 11e17;
    address public usdeAddress;

    constructor(address _usdeToken) Ownable(msg.sender) ERC20("Staked USDE", "sUSDe") {
        _mint(msg.sender, 1000000000000000000000000000);
        usdeAddress = _usdeToken;
    }

    function deposit(uint256 amount, address receiver) public returns (uint256) {
        uint256 afterSwap = convertToShares(amount);
        IERC20(usdeAddress).safeTransferFrom(receiver, address(this), amount);
        _mint(receiver, afterSwap);
        return afterSwap;
    }

    function cooldownShares(uint256 amount) public {}

    function convertToShares(uint256 amount) public view returns (uint256) {
        return amount * 1e18 / mockedRate;
    }

    function previewRedeem(uint256 _shares) public view returns (uint256) {
        return _shares * mockedRate / 1e18;
    }

    function unstake(uint256 _shares) public {
        uint256 amount = previewRedeem(_shares);
        ERC20Burnable(address(this)).burn(_shares);
        IERC20(usdeAddress).safeTransfer(msg.sender, amount);
    }
}
