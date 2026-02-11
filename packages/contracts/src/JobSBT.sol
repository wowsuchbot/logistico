// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title JobSBT
/// @notice Non-transferable (Soulbound) token minted to a Laborer's TBA upon Order fulfillment.
contract JobSBT is ERC721, Ownable {
    bytes32 public immutable zoneId;

    /// @dev jobId => exists (for idempotent minting)
    mapping(uint256 => bool) public jobMinted;

    event JobSBTMinted(uint256 indexed jobId, address indexed toTBA, bytes32 indexed zoneId);

    constructor(string memory name_, string memory symbol_, bytes32 zoneId_)
        ERC721(name_, symbol_)
        Ownable(msg.sender)
    {
        zoneId = zoneId_;
    }

    function mint(address toTBA, uint256 jobId) external onlyOwner {
        require(!jobMinted[jobId], "JobSBT: already minted");
        jobMinted[jobId] = true;
        _safeMint(toTBA, jobId);
        emit JobSBTMinted(jobId, toTBA, zoneId);
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override
        returns (address)
    {
        address from = _ownerOf(tokenId);
        require(from == address(0), "JobSBT: soulbound, cannot transfer");
        return super._update(to, tokenId, auth);
    }
}
