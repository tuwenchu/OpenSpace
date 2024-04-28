// //SPDX-License-Identifier: MIT
pragma solidity  0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721Mock is ERC721 {

constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) { }



function mint(address to, uint256 tokenId) public {
       
       _mint(to, tokenId);
    }

    function burn( uint256 tokenId) internal {
        
       _burn(tokenId);
    }
}
