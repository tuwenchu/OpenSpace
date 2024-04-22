// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
  contract Bank {
    address public owner; // 合约所有者的地址
    
    event Deposit (address indexed from , uint256 amount); // 存款函数
    event Withdrawal (address indexed from , uint256 amount);

    mapping (address => uint256) public userDeposit;// 地址和金额做个映射

    constructor() {
        owner = msg.sender;
    }
     
    modifier minimumDeposit(uint256 minAmount) { // 修饰符，用于限制最小存款金额

        require(msg.value >= minAmount, "Deposit amount must be greater than or equal to 0.001 ether.");
        _;
    } 
    // 接收函数 internal
    function deposit() virtual public payable minimumDeposit(0.001 ether)  {

        userDeposit[msg.sender] += msg.value;
        updateTopThree(msg.sender, userDeposit[msg.sender]);  // 更新前三位用户存款金额
        emit Deposit (msg.sender,msg.value);
    }
    receive() external payable  {
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
         // 前三位用户地址和存款金额
    address[3] public topThreeUsers;  //地址
     // 更新前三位用户存款金额的内部函数
    function updateTopThree(address user, uint256 amount) internal {
        if (amount > userDeposit[topThreeUsers[0]]) {

            if (topThreeUsers[1] == user ) {
                topThreeUsers[1] = topThreeUsers[0];
                topThreeUsers[0] = user;
            } else {
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
    
    constructor(){
    owner = msg.sender;
    }
    // 存款到银行的函数
    function deposit() public override payable minimumDeposit(0.001 ether){

        userDeposit[msg.sender] += msg.value;
        updateTopThree(msg.sender, userDeposit[msg.sender]);
        emit Deposit (msg.sender,msg.value);
    }
    // 把 BigBank 的管理员转移给 Ownable 合约
    function transferOwner(address _newOwner) public {

         require(msg.sender == owner, 'Not owner');
         require(_newOwner != address(0), "0 address");

         owner = _newOwner;
    }
}

  contract Ownable  {

      BigBank bigBank;
      address public owner;

      constructor(address _bigBank){

        bigBank = BigBank(payable(_bigBank));
        owner = msg.sender;

      }

      modifier onlyOwner (){
        require(msg.sender == owner, 'notowner ');
        _;
      }
       
    receive() external payable {} // 接收 ETH 的默认回调函数
    
    function withdrawal(uint256 amount) public onlyOwner{

    bigBank.withdrawal(amount);

    }
    //身份转移
    function transferBigBankOwner(address _newOwner) public{

    bigBank.transferOwner(_newOwner);

    }
}
