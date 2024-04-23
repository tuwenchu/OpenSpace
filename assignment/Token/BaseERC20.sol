// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BaseERC20 {
    string public name; 
    string public symbol; 
    uint8 public decimals; 

    uint256 public totalSupply; 

    mapping (address => uint256) balances; 

    mapping (address => mapping (address => uint256)) allowances; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        // write your code here
        // set name,symbol,decimals,totalSupply

        name = "BaseERC20";

        symbol = "BERC20";

        decimals = 18;

        totalSupply = 100000000*10**18;

        balances[msg.sender] = totalSupply;  
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        // write your code here
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        // write your code here 
        uint256 balance = balances[msg.sender];
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");
        balances[msg.sender] = balance - _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);  
        return true;   
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // write your code here
        uint256 allowancess = allowances[_from][msg.sender];
        require(allowancess >= _value, "ERC20: transfer amount exceeds allowance");
        allowances[_from][msg.sender] = allowancess - _value;

        uint256 balance = balances[_from];
        require(balance >= _value, "ERC20: transfer amount exceeds balance");
        balances[_from] = balance - _value;
        balances[_to] += _value;
        
        emit Transfer(_from, _to, _value); 
        return true; 
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        // write your code here
        allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value); 
        return true; 
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {   
        // write your code here     
        return allowances[_owner][_spender];
    }
}

设置代币名称（name）："BaseERC20"
设置代币符号（symbol）："BERC20"
设置Token小位数：18
设置Token总体（totalSupply）:100,000,000
允许任何人查看任何地址的代币余额（balanceOf）
允许Token的所有者将他们的Token发送给任何人（转账）；转帐超出余额时发送异常(require)，并显示错误消息“ERC20：转账金额超出余额”。
允许 Token 的所有者批准某个地址消费他们的一部分 Token（批准）
允许任何人查看一个地址可以从其他账户中转账的代币数量（允许）
允许被授权的地址消费他们被授权的Token数量（transferFrom）；
转帐超出授权数量时发送异常(require)，异常信息：“ERC20: 转账金额超出余额”
转帐超出授权数量时发送异常(require)，异常消息：“ERC20：转账金额超出限额”。
注意：
在编写合约时，需要遵循 ERC20 标准，此外还需要考虑安全性，确保转账和授权功能在任何时候都能正常运行无误。
代码模板中已包含基础框架，只需要在标记为“Write your code here”的位置编写了您的代码。不要去修改现有内容！












