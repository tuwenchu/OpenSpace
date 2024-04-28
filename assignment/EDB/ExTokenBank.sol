// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC1820Registry.sol";

interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

contract Bank is TokenRecipient {
    mapping(address => uint) public deposited; // 存储每个地址的存款量的映射
    address public immutable token; // 代币合约地址，不可更改

    // // ERC1820注册表地址
    // IERC1820Registry private erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    // // ERC777TokensRecipient接口的哈希值
    // bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
    //   0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;

    // 构造函数，初始化代币地址
    constructor(address _token) {
        token = _token;
        // 在部署时注册ERC777TokensRecipient接口实现者
        // erc1820.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
    }

    // 外部函数，处理接收代币的逻辑
    function tokensReceived(address sender, uint amount) external returns (bool) {
        require(msg.sender == token, "invalid"); // 只能由代币合约调用
        deposited[sender] += amount; // 增加发送者的存款量
        return true;
    }

    // 存款函数，用户向合约转账一定数量的代币
    function deposit(address user, uint amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount); // 从用户转账代币到合约
        deposited[user] += amount; // 增加用户的存款量
    }

    // 基于代币的许可功能，用户授权合约代表他们存款一定数量的代币
    function permitDeposit(address user, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        IERC20Permit(token).permit(msg.sender, address(this), amount, deadline, v, r, s); // 许可代币转账
        deposit(user, amount); // 执行存款操作
    }

    // ERC777接口的回调函数，处理接收代币的逻辑
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        require(msg.sender == token, "invalid"); // 只能由代币合约调用
        deposited[from] += amount; // 增加发送者的存款量
    }
}
