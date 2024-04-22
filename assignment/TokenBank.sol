// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract TokenBank {
mapping (address => uint256 ) deposits; // 地址的存入数量
mapping (address => uint256 ) balances; // 存入余额的数量
event Deposits (address indexed  account , uint256 amount);
event Withdraw (address indexed  account , uint256 amount);

modifier depositAmount (uint256 _amount){
    require(_amount > 0, 'Deposit amount must be greater than 0'); _;
}
function deposit(uint256 _amount ) public depositAmount(_amount){
 deposits[msg.sender] += _amount; //     存入数量
 balances[msg.sender] += _amount; //     余额
 emit Deposits(msg.sender,_amount);
}
modifier withdrawAmount (uint256 _amount) {
    require(_amount > 0, 'Deposit amount must be greater than 0'); 
    require(balances[msg.sender] >= _amount , 'Deposit amount must be greater than 0'); 
    _;
}
function withdraw(uint256 _amount) withdrawAmount(_amount)public { 
 deposits[msg.sender] -= _amount; 
 balances[msg.sender] -= _amount; 
 emit Withdraw(msg.sender,_amount);
}
}
