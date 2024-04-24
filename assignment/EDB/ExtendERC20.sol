//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 扩展 ERC20 合约，使其具备在转账的时候，如果目标地址是合约的话，调用目标地址的 tokensReceived() 方法.
// 请贴出你的代码或代码库链接。

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

// 定义一个接口，用于处理代币接收的回调
interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

// 自定义合约 MyERC20Callback，继承 ERC20 合约
contract MyERC20Callback is ERC20 {
    using Address for address;

    constructor() ERC20("MyERC20", "MyERC20") {
        // 合约创建时，向部署者发行 1000 个代币
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    // 执行转账操作，并在目标地址是合约的情况下调用 tokensReceived 方法
    function transferWithCallback(address recipient, uint256 amount) external returns (bool) {
        // 执行 ERC20 的转账操作
        _transfer(msg.sender, recipient, amount);

        //// 地址有代码说明是合约
        if (recipient.code.length > 0 ) {
            // 调用 TokenRecipient 接口的 tokensReceived 方法，并传递转账的信息
            bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount);
            // 检查 tokensReceived 是否成功接收代币
            require(rv, "No tokensReceived");
        }

        return true;
    }
}
