// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./LogisticsZone.sol";

/// @title LogisticsFactory
/// @notice Deploys tenant-specific LogisticsZone instances via ERC-1167 minimal proxy (Clones).
contract LogisticsFactory {
    address public immutable zoneImplementation;
    address public immutable registry;
    address public immutable tbaImplementation;
    uint256 public immutable chainId;

    event ZoneDeployed(
        bytes32 indexed zoneId,
        string tenantId,
        address indexed zoneAddress,
        address indexed deployedBy
    );

    constructor(
        address registry_,
        address tbaImplementation_,
        uint256 chainId_
    ) {
        zoneImplementation = address(new LogisticsZone());
        registry = registry_;
        tbaImplementation = tbaImplementation_;
        chainId = chainId_;
    }

    /// @notice Deploy a new LogisticsZone clone for a tenant.
    /// @param zoneId_ Unique zone identifier (e.g. keccak256(abi.encode(tenantId)))
    /// @param tenantId_ Human-readable tenant id (e.g. "agency1")
    /// @param salt Salt for CREATE2 (deterministic address)
    function deployZone(bytes32 zoneId_, string calldata tenantId_, bytes32 salt)
        external
        returns (address zone)
    {
        zone = Clones.cloneDeterministic(zoneImplementation, salt);
        LogisticsZone(zone).initialize(
            zoneId_,
            tenantId_,
            registry,
            tbaImplementation,
            chainId
        );
        emit ZoneDeployed(zoneId_, tenantId_, zone, msg.sender);
        return zone;
    }

    function predictZoneAddress(bytes32 salt) external view returns (address) {
        return Clones.predictDeterministicAddress(zoneImplementation, salt);
    }
}
