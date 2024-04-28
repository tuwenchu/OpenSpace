//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarket is IERC721Receiver {
    mapping(uint => uint) public tokenIdPrice; //  ID -> 价格
    mapping(uint => address) public tokenSeller; // ID -> 地址
    address public immutable token;
    address public immutable nftToken;

    constructor(address _token, address _nftToken) {
        token = _token;
        nftToken = _nftToken;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
      return this.onERC721Received.selector;
    }

    // approve(address to, uint256 tokenId) first
    function list(uint tokenID, uint amount) public {

      IERC721(nftToken).safeTransferFrom(msg.sender, address(this), tokenID, "");  // -->  nft 转到合约里面
       // safeTransferFrom查接收者是否是一个合约，并调用该合约的onERC721Received函数，
       //以确保接收合约能够正确处理接收到的NFT。 

      tokenIdPrice[tokenID] = amount; // 记录价格
      tokenSeller[tokenID] = msg.sender; // 记录所有者地址
    }

    function buy(uint tokenId, uint amount) external {

      require(amount >= tokenIdPrice[tokenId], "low price");
      require(IERC721(nftToken).ownerOf(tokenId) == address(this), "aleady selled");
      
      IERC20(token).transferFrom(msg.sender, tokenSeller[tokenId], tokenIdPrice[tokenId]);  // // 把token给到卖家
      IERC721(nftToken).transferFrom(address(this), msg.sender, tokenId);  // nft 把nft给到买家
       
      
    }
        // 买家从 token 合约转移代币到市场合约
    function tokensReceived(
        address buyer,
        uint256 amount,
        address nftAddress,
        uint256 tokenId
    ) public {
        require(msg.sender == address(token), "must be token contract");  // 确保调用者是代币合约
        require(IERC721(nftAddress).ownerOf(tokenId) == address(this), "not owned by market");  // 确保NFT在市场合约中
        require(tokenIdPrice[tokenId] > 0, "not for sale");  // 确保NFT在市场上出售

        // 转移token给卖家
        IERC20(token).transfer(tokenSeller[tokenId], tokenIdPrice[tokenId]);
        // 转移NFT给买家
        IERC721(nftAddress).transferFrom(address(this), buyer, tokenId);

        // 更新状态
        delete tokenIdPrice[tokenId];
        delete tokenSeller[tokenId];
    }
  
}

// 编写一个简单的NFT市场合约，使用自己发行的Token来买卖NFT，函数的方法有：
// list()：实现上架功能，NFT持有者可以设定一个价格（需要多少个代币购买该NFT）并上架NFT到NFT市场。
// buyNFT()：实现购买NFT功能，用户转入所定价的代币数量，获得对应的NFT。 nft买家，token给卖家
// 扩展挑战Token 购买 NFT 合约，能够使用ERC20扩展中的回调函数来购买某个 NFT ID。 nft买家，token给卖家