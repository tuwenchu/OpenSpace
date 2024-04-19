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
    // / 修饰符，用于限制最小存款金额
    modifier minimumDeposit(uint256 minAmount) {
        require(msg.value >= minAmount, "Deposit amount must be greater than or equal to 0.001 ether.");
        _; // Continue with the function if the condition is met
    }
    // 接收函数 internal
    function deposit() public payable minimumDeposit(0.001 ether)  {
        // require( msg.value > 0, 'The deposit amount cannot be less than 0' );
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
    // 转移管理员
    function transferOwner( address newOwner) public {
        require(msg.sender == owner, 'You are not an administrator and cannot transfer your identity');
        owner = newOwner;
    }
         // 前三位用户地址和存款金额
    address[3] public topThreeUsers;  //地址
     // 更新前三位用户存款金额的内部函数
    function updateTopThree(address user, uint256 amount) internal {
        if (amount > userDeposit[topThreeUsers[0]]) {
            if(topThreeUsers[1] == user ) {
                topThreeUsers[1] = topThreeUsers[0];
                topThreeUsers[0] = user;
            }else {
                topThreeUsers[2] = topThreeUsers[1];
                topThreeUsers[1] = topThreeUsers[0];
                topThreeUsers[0] = user;
            }
        } else if (amount > userDeposit[topThreeUsers[1]]) {
            topThreeUsers[2] = topThreeUsers[1];
            topThreeUsers[1] = user;
        } else if (amount > userDeposit[topThreeUsers[2]]) {
            topThreeUsers[2] = user;
        }
    } 
}
contract BigBank is Bank {
 // 管理员
 constructor(){
    owner = msg.sender;
 }
    // 存款到银行的函数，重用父合约的修饰符
    function depositToBank() external payable minimumDeposit(0.001 ether) {
        // 调用父合约的存款函数
        super.deposit();
    }
    // BigBank 合约支持转移管理员
    function transferBankOwner(address _newOwner) public {
        super.transferOwner(_newOwner);
    }
    // 把 BigBank 的管理员转移给 Ownable 合约
    function transferOwnableOwner(address _newOwner) public {
         require(msg.sender == owner, 'Not owner');
         require(_newOwner != address(0), "0 address");
        owner = _newOwner;
    }
}
// 同时编写了一个 Ownable 合约，把 BigBank 的管理员转移给 Ownable 合约，
// 实现只有 Ownable 可以调用 BigBank 的withdraw()。
contract Ownable  {
      BigBank bigBank;
      constructor(address _bigBank){
        bigBank = BigBank(payable(_bigBank));
      }
       // 接收 ETH 的默认回调函数
    receive() external payable {}
   function withdrawal(uint256 amount) public {
    bigBank.withdrawal(amount);
   }
   //身份转移
   function transferBigBankOwner(address _newOwner) public{
    bigBank.transferOwnableOwner(_newOwner);
   }
}
// 测试
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4. 输入1
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2  输入2 第二次输入4
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db  输入3。 

// 第一 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 第二 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// 第三 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2