// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    // 存款事件
    event Deposit(address indexed from, uint256 amount);
    // 提款事件
    event Withdrawal(address indexed to, uint256 amount);

    // 用户地址与存款金额的映射
    mapping(address => uint256) public userDeposit;

    // 合约所有者地址
    address public owner;

    // 存储金额前三位用户地址
    address[3] public topThreeUsers;

    // 存储金额前三位用户存款金额
    uint256[3] public topThreeAmounts;

    constructor() {
        owner = msg.sender;
    }

    // 存款函数，接收用户的转账金额并触发存款事件
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        // 更新用户存款金额
        userDeposit[msg.sender] += msg.value;

        // 更新前三位用户
        updateTopThree(msg.sender, userDeposit[msg.sender]);

        // 触发存款事件
        emit Deposit(msg.sender, msg.value);
    }

    // 合约接收 ETH 的默认回调函数
    receive() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        // 更新用户存款金额
        userDeposit[msg.sender] += msg.value;

        // 更新前三位用户
        updateTopThree(msg.sender, userDeposit[msg.sender]);

        // 触发存款事件
        emit Deposit(msg.sender, msg.value);
    }

    // 提取合约余额的函数，只有合约所有者（管理员）可以调用
    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only owner can call this function");

        // 确保提取金额不超过合约余额
        // require(amount <= address(this).balance, "Insufficient balance");
        if(amount > address(this).balance) {
            amount = address(this).balance;
        }
        // 转账给合约所有者
        payable(msg.sender).transfer(amount);

        // 触发提款事件
        emit Withdrawal(msg.sender, amount);
    }

    // 更新前三位用户的内部函数
    function updateTopThree(address user, uint256 amount) internal {
        // 查找是否已经存在当前用户，如果存在则更新存款金额，否则添加新用户
        uint256 index = 3; // 默认超出前三位
        for (uint256 i = 0; i < 3; i++) {
            if (topThreeUsers[i] == user) {
                index = i;
                break;
            } else if (amount > topThreeAmounts[i]) {
                index = i;
                break;
            }
        }

        // 更新前三位用户信息
        if (index < 3) {
            if (topThreeUsers[index] == user) {
                topThreeAmounts[index] = amount;
            } else {
                for (uint256 j = 2; j > index; j--) {
                    topThreeUsers[j] = topThreeUsers[j - 1];
                    topThreeAmounts[j] = topThreeAmounts[j - 1];
                }
                topThreeUsers[index] = user;
                topThreeAmounts[index] = amount;
            }
        }
    }

    // 获取存储金额前三位用户地址的函数
    function getTopThreeUsers() public view returns (address[3] memory) {
        return topThreeUsers;
    }

    // 获取存储金额前三位用户存款金额的函数
    function getTopThreeAmounts() public view returns (uint256[3] memory) {
        return topThreeAmounts;
    }
}
