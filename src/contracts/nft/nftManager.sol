//SPDX-License-Identifier: MIT

import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {Events} from "../common/Events.sol";

pragma solidity ^0.8.0;

contract NftManager is Ownable(msg.sender) {
    using SafeERC20 for IERC20;

    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Listing)) public m_listings;
    mapping(address => uint256) private s_proceeds;

    modifier notListed(address nftContract, uint256 tokenId) {
        Listing memory listing = m_listings[nftContract][tokenId];
        require(listing.price <= 0, "Already listed");
        _;
    }

    modifier isListed(address nftContract, uint256 tokenId) {
        Listing memory listing = m_listings[nftContract][tokenId];
        require(listing.price > 0, "Not listed");
        _;
    }

    modifier isOwner(
        address nftContract,
        uint256 tokenId,
        address spender
    ) {
        // Assume a function ownerOf exists in the NFT contract
        address owner = IERC721(nftContract).ownerOf(tokenId);
        require(spender == owner, "Not owner");
        _;
    }

    function listItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    )
        public
        notListed(nftContract, tokenId)
        isOwner(nftContract, tokenId, msg.sender)
    {
        require(price > 0, "Price must be above zero");
        IERC721 nft = IERC721(nftContract);
        require(
            nft.getApproved(tokenId) == address(this),
            "Not approved for marketplace"
        );

        m_listings[nftContract][tokenId] = Listing(msg.sender, price);
        emit Events.ItemListed(msg.sender, nftContract, tokenId, price);
    }
}
