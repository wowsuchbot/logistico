// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IERC6551Registry.sol";

/// @title LaborerNFT
/// @notice ERC-721 representing a Laborer (Bike, Drone, or AI Bot). Each token has an ERC-6551 TBA.
contract LaborerNFT is ERC721, Ownable {
    IERC6551Registry public immutable registry;
    address public immutable tbaImplementation;
    uint256 public immutable chainId;
    bytes32 public immutable zoneId;

    /// @dev Optional: zk_proof_commitment for Personhood or Bot Certification (metadata / off-chain or extension).
    mapping(uint256 => bytes32) public zkProofCommitment;

    event LaborerMinted(uint256 indexed tokenId, address indexed tba, bytes32 indexed zoneId);
    event ZkProofCommitmentSet(uint256 indexed tokenId, bytes32 commitment);

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
        address tba = registry.account(
            tbaImplementation,
            bytes32(tokenId),
            chainId,
            address(this),
            tokenId
        );
        emit LaborerMinted(tokenId, tba, zoneId);
    }

    function setZkProofCommitment(uint256 tokenId, bytes32 commitment) external {
        require(ownerOf(tokenId) == msg.sender || owner() == msg.sender, "LaborerNFT: not authorized");
        zkProofCommitment[tokenId] = commitment;
        emit ZkProofCommitmentSet(tokenId, commitment);
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
