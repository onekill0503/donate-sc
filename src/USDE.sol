import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract USDE is ERC20, ERC20Burnable, Ownable {
    using SafeERC20 for IERC20;

    constructor() Ownable(msg.sender) ERC20("USDE", "USDe") {
        _mint(msg.sender, 1000000000000000000000000000);
    }
}
