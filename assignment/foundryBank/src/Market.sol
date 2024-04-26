//SPDX-License-Identifier: MIT
pragma solidity  0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarket is IERC721Receiver {
    mapping(uint => uint) public tokenIdPrice;  // id -> Price
    mapping(uint => address) public tokenSeller; // id -> Seller
  
    address public immutable token;
    address public immutable nftToken;

 
    constructor(address _token, address _nftToken) {
        token = _token;    
        nftToken = _nftToken;
    }

    // approve(address to, uint256 tokenId) first market
   // 上架逻辑 代币持有者把手中的代币转移到合约中   记录上架的价格和 持有者的地址
    function list(uint tokenID, uint amount) public {

        IERC721(nftToken).safeTransferFrom(msg.sender, address(this), tokenID, ""); // 把tokenID 对应的nft放到

        tokenIdPrice[tokenID] = amount;
        tokenSeller[tokenID] = msg.sender; 
    } 
    //  safeTransferFrom是否生效，是把合约转上去了
    //  记录对不对   // 授权

    function buy(uint tokenId, uint amount) external {

      require(amount >= tokenIdPrice[tokenId], "low price");
      require(IERC721(nftToken).ownerOf(tokenId) == address(this), "aleady selled");

      // transferFrom 代币转移到卖家
      IERC20(token).transferFrom(msg.sender, tokenSeller[tokenId], tokenIdPrice[tokenId]);  // token 

      // nft转移给买家         tokenId -> NFT 的 ID
      IERC721(nftToken).transferFrom(address(this), msg.sender, tokenId);  // nft
      
    }


     function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
      return this.onERC721Received.selector;
    }


}

// 编写一个简单的NFT市场合约，使用自己发行的Token来买卖NFT，函数的方法有：
// list()：实现上架功能，NFT持有者可以设定一个价格（需要多少个代币购买该NFT）并上架NFT到NFT市场。
// buyNFT()：实现购买NFT功能，用户转入所定价的代币数量，获得对应的NFT。