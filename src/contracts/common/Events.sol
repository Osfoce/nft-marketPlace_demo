//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Events {
    event ItemListed{address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 price};
    event ItemBought{address indexed buyer, address indexed nftContract, uint256 indexed tokenId, uint256 price};
    event ItemCanceled{address indexed seller, address indexed nftContract, uint256 indexed tokenId};
    
}