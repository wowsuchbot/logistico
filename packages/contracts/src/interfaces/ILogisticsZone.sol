// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ILogisticsZone
/// @notice Interface for tenant-isolated logistics zones (laborers, orders, job SBTs).
interface ILogisticsZone {
    // ─── Zone identity ─────────────────────────────────────────────────────
    function zoneId() external view returns (bytes32);
    function tenantId() external view returns (string memory);
    function laborerNFT() external view returns (address);
    function orderNFT() external view returns (address);
    function jobSBT() external view returns (address);

    // ─── Order lifecycle (indexed for Phoenix) ─────────────────────────────
    event JobStarted(
        bytes32 indexed zoneId,
        uint256 indexed orderTokenId,
        uint256 indexed laborerTokenId,
        address laborerTBA,
        uint256 startedAt
    );
    event JobAttested(
        bytes32 indexed zoneId,
        uint256 indexed orderTokenId,
        uint256 indexed laborerTokenId,
        bytes proofData,
        uint256 attestedAt
    );
    event JobCompleted(
        bytes32 indexed zoneId,
        uint256 indexed orderTokenId,
        uint256 indexed laborerTokenId,
        address laborerTBA,
        uint256 completedAt
    );

    function startJob(uint256 orderTokenId, uint256 laborerTokenId) external;
    function attestJob(uint256 orderTokenId, uint256 laborerTokenId, bytes calldata proofData) external;
    function completeJob(uint256 orderTokenId, uint256 laborerTokenId) external;
}
