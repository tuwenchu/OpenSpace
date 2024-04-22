// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20.sol";

// TokenBank 合约用于存储用户的 Token，并提供存款和取款功能
contract TokenBank {

    //  用户的地址。合约的地址 
    mapping(address => mapping(address => uint256)) public TokenBalances;

    constructor() {}

    // 存款函数，用户可以将 Token 存入 TokenBank 合约
    function deposit(address token, uint256 _value) public {

        BaseERC20 ERC20 = BaseERC20(token);

        ERC20.transferFrom(msg.sender, address(this), _value);
        
        TokenBalances[token][msg.sender] += _value;
    }
    

    // 取款函数，用户可以从 TokenBank 合约取回存入的 Token
    function withdraw(address token, uint256 _value) public {

        require(_value <= TokenBalances[token][msg.sender], "withdraw amount exceeds balance");

        // 创建 BaseERC20 类型的实例
        BaseERC20 ERC20 = BaseERC20(token);

        ERC20.transfer(address(msg.sender), _value);
        
        TokenBalances[token][msg.sender] -= _value;
    }
}
