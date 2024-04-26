// SPDX-License-Identifier: UNLICENSED
pragma solidity  0.8.20;
import { Test, console } from "forge-std/Test.sol";
import { NFTMarket } from "../src/Market.sol";
import { ERC721Mock } from './mock/ERC721mocklist.sol';
 import { BaseERC20 } from '../src/BaseERC20.sol';
contract NFTMarketTest is Test {
    
    NFTMarket  mkt;

    ERC721Mock nft; // mint

    address alice = makeAddr('alice'); // 地址打印方便


    BaseERC20 ercToken ;

 // 初始化要有nft
    function setUp() public {

        //   vm.startPrank(alice) ;

          nft = new ERC721Mock('sl','sl');

          ercToken = new BaseERC20();

          mkt = new NFTMarket(address(ercToken) , address(nft) );

    } 
    // 1.没有授权转账失败的案例
    function test_list() public {

      nft.mint(alice,1);
      vm.startPrank(alice);

      nft.setApprovalForAll(address(mkt),true);

      mkt.list(1,10);

      assertEq( mkt.tokenSeller(1) , alice,'alice----------error');

    } 
    function test_buy() public {

     test_list();
 
     address bom = makeAddr('bom');
     
    //  vm.prank(alice);

    //  ercToken.transfer(bom,1000000);
     
     ercToken.mint(bom,100000);

     vm.startPrank(bom);

     ercToken.approve(address(mkt),10000);

     mkt.buy(1,12);
     
     assertEq(nft.ownerOf(1) ,bom ,'bom--------------->');

    } 

}



