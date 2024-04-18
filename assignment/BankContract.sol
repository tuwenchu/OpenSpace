// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 contract Bank {
   address public owner; // 合约所有者的地址
    // 存款函数
    event Deposit (address indexed from , uint256 amount);
    // 管理员
    event Withdrawal (address indexed from , uint256 amount);
    // 地址和金额做个映射
    mapping (address => uint256) public userDeposit;
    constructor() {
        owner = msg.sender;
    }
    // 接收函数
    function deposit() external  payable {
        require( msg.value > 0, 'The deposit amount cannot be less than 0' );
        userDeposit[msg.sender]+= msg.value;
        emit Deposit (msg.sender,msg.value);
          // 更新前三位用户存款金额
        updateTopThree(msg.sender, userDeposit[msg.sender]);
    }
    receive() external payable  {
    require(msg.value > 0, 'The deposit amount cannot be less than 0');
     // 更新前三位用户
    }
    // 管理员方法
    function withdrawal(uint amount) public{
        require( msg.sender ==  owner,'Only administrators can extract');
        if( amount > address(this).balance) {
            amount = address(this).balance;
        }
        // 转账给合约所有者
        payable(msg.sender).transfer(amount);
        emit Withdrawal (msg.sender ,amount );
    }
     // 更新前三位用户存款金额的内部函数
    function updateTopThree(address user, uint256 amount) internal {
        if (amount > topThreeAmounts[0]) {
            topThreeAmounts[2] = topThreeAmounts[1];
            topThreeAmounts[1] = topThreeAmounts[0];
            topThreeAmounts[0] = amount;

            topThreeUsers[2] = topThreeUsers[1];
            topThreeUsers[1] = topThreeUsers[0];
            topThreeUsers[0] = user;
        } else if (amount > topThreeAmounts[1]) {
            topThreeAmounts[2] = topThreeAmounts[1];
            topThreeAmounts[1] = amount;

            topThreeUsers[2] = topThreeUsers[1];
            topThreeUsers[1] = user;
        } else if (amount > topThreeAmounts[2]) {
            topThreeAmounts[2] = amount;
            topThreeUsers[2] = user;
        }
    }
       // 前三位用户地址和存款金额
    address[3] public topThreeUsers;
    uint256[3] public topThreeAmounts;
    
}
// 2.在银行记录您每个地址的存款金额
// 3.编写withdraw() 方法，仅管理员可以通过该方法提取资金。
//使用存储记录金额的前 3 位用户