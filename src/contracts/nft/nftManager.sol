//SPDX-License-Identifier: MIT

import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

contract NftManager is Ownable(msg.sender) {
    mapping(address => bool) public NftContracts;

    event NftContractAdded(address indexed NftContract);
    event NftContractRemoved(address indexed NftContract);

    function addNftContract(address _NftContract) external onlyOwner {
        require(_NftContract != address(0), "Invalid address");
        NftContracts[_NftContract] = true;
        emit NftContractAdded(_NftContract);
    }

    function removeNftContract(address _NftContract) external onlyOwner {
        require(NftContracts[_NftContract], "Nft contract not found");
        NftContracts[_NftContract] = false;
        emit NftContractRemoved(_NftContract);
    }

    function isNftContract(address _NftContract) external view returns (bool) {
        return NftContracts[_NftContract];
    }
}
