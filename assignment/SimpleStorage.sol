// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;
// 第一个合约
contract Counter {
  uint counter;
  constructor(){
   counter = 1;
  }

function get() public view returns (uint) {
        return counter;
    }
    function add(uint x) public {
        counter = counter + x;
    }
}

 
