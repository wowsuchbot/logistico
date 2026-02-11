// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IERC6551Registry.sol";

/// @title OrderNFT
/// @notice ERC-721 representing a Job/Order. Token's TBA holds payment in escrow.
contract OrderNFT is ERC721, Ownable {
    IERC6551Registry public immutable registry;
    address public immutable tbaImplementation;
    uint256 public immutable chainId;
    bytes32 public immutable zoneId;

    constructor(
        string memory name_,
        string memory symbol_,
        bytes32 zoneId_,
        address registry_,
        address tbaImplementation_,
        uint256 chainId_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        zoneId = zoneId_;
        registry = IERC6551Registry(registry_);
        tbaImplementation = tbaImplementation_;
        chainId = chainId_;
    }

    function mint(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }

    function getTBA(uint256 tokenId) public view returns (address) {
        return registry.account(
            tbaImplementation,
            bytes32(tokenId),
            chainId,
            address(this),
            tokenId
        );
    }
}
