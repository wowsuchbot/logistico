// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./interfaces/ILogisticsZone.sol";
import "./LaborerNFT.sol";
import "./OrderNFT.sol";
import "./JobSBT.sol";

/// @title LogisticsZone
/// @notice Tenant-isolated zone: laborers, orders, job SBTs; emits events for Phoenix indexer.
/// @dev Clone-friendly: use initialize() when deployed via Factory (ERC-1167).
contract LogisticsZone is ILogisticsZone {
    bytes32 public override zoneId;
    string public override tenantId;

    LaborerNFT public laborerNFTContract;
    OrderNFT public orderNFTContract;
    JobSBT public jobSBTContract;

    function laborerNFT() external view override returns (address) { return address(laborerNFTContract); }
    function orderNFT() external view override returns (address) { return address(orderNFTContract); }
    function jobSBT() external view override returns (address) { return address(jobSBTContract); }

    address public registry;
    address public tbaImplementation;
    uint256 public chainId;

    enum OrderStatus { None, Available, Started, Attested, Completed }
    mapping(uint256 => OrderStatus) public orderStatus;
    mapping(uint256 => uint256) public orderToLaborer; // orderTokenId => laborerTokenId
    uint256 public jobCounter;

    address public zoneOwner;
    bool private initialized;

    modifier onlyZoneOwner() {
        require(msg.sender == zoneOwner, "LogisticsZone: not zone owner");
        _;
    }

    /// @dev Initializer for clone; call once after deployment by Factory.
    function initialize(
        bytes32 zoneId_,
        string memory tenantId_,
        address registry_,
        address tbaImplementation_,
        uint256 chainId_
    ) external {
        require(!initialized, "LogisticsZone: already initialized");
        initialized = true;
        zoneId = zoneId_;
        tenantId = tenantId_;
        registry = registry_;
        tbaImplementation = tbaImplementation_;
        chainId = chainId_;
        zoneOwner = msg.sender;

        laborerNFTContract = new LaborerNFT(
            string(abi.encodePacked("Laborer ", _bytes32ToHex(zoneId_))),
            "LAB",
            zoneId_,
            registry_,
            tbaImplementation_,
            chainId_
        );
        orderNFTContract = new OrderNFT(
            string(abi.encodePacked("Order ", _bytes32ToHex(zoneId_))),
            "ORD",
            zoneId_,
            registry_,
            tbaImplementation_,
            chainId_
        );
        jobSBTContract = new JobSBT(
            string(abi.encodePacked("JobSBT ", _bytes32ToHex(zoneId_))),
            "JOB",
            zoneId_
        );

        laborerNFTContract.transferOwnership(msg.sender);
        orderNFTContract.transferOwnership(msg.sender);
        // JobSBT ownership stays with Zone so completeJob() can mint
    }

    /// @dev Parameterless constructor for the implementation contract (clone target). Do not call initialize on implementation.
    constructor() {}

    function startJob(uint256 orderTokenId, uint256 laborerTokenId) external override {
        require(orderNFTContract.ownerOf(orderTokenId) == msg.sender || msg.sender == zoneOwner, "LogisticsZone: not order owner");
        require(orderStatus[orderTokenId] == OrderStatus.Available, "LogisticsZone: order not available");
        orderStatus[orderTokenId] = OrderStatus.Started;
        orderToLaborer[orderTokenId] = laborerTokenId;

        address laborerTBA = laborerNFTContract.getTBA(laborerTokenId);
        emit JobStarted(zoneId, orderTokenId, laborerTokenId, laborerTBA, block.timestamp);
    }

    function attestJob(uint256 orderTokenId, uint256 laborerTokenId, bytes calldata proofData) external override {
        require(orderStatus[orderTokenId] == OrderStatus.Started, "LogisticsZone: order not started");
        require(orderToLaborer[orderTokenId] == laborerTokenId, "LogisticsZone: laborer mismatch");
        orderStatus[orderTokenId] = OrderStatus.Attested;
        emit JobAttested(zoneId, orderTokenId, laborerTokenId, proofData, block.timestamp);
    }

    function completeJob(uint256 orderTokenId, uint256 laborerTokenId) external override {
        require(orderStatus[orderTokenId] == OrderStatus.Attested, "LogisticsZone: order not attested");
        require(orderToLaborer[orderTokenId] == laborerTokenId, "LogisticsZone: laborer mismatch");
        orderStatus[orderTokenId] = OrderStatus.Completed;

        address laborerTBA = laborerNFTContract.getTBA(laborerTokenId);
        jobCounter++;
        jobSBTContract.mint(laborerTBA, jobCounter);

        emit JobCompleted(zoneId, orderTokenId, laborerTokenId, laborerTBA, block.timestamp);
    }

    function setOrderAvailable(uint256 orderTokenId) external onlyZoneOwner {
        orderStatus[orderTokenId] = OrderStatus.Available;
    }

    function _bytes32ToHex(bytes32 x) internal pure returns (string memory) {
        bytes memory s = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            uint8 b = uint8(x[i]);
            s[i * 2] = _toHexChar(b / 16);
            s[i * 2 + 1] = _toHexChar(b % 16);
        }
        return string(s);
    }

    function _toHexChar(uint8 d) internal pure returns (bytes1) {
        if (d < 10) return bytes1(uint8(bytes1("0")) + d);
        return bytes1(uint8(bytes1("a")) + d - 10);
    }
}
