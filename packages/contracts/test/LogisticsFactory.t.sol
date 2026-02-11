// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/LogisticsFactory.sol";
import "../src/LogisticsZone.sol";
import "../src/LaborerNFT.sol";
import "../src/OrderNFT.sol";
import "../src/JobSBT.sol";

contract MockRegistry {
    function account(address, bytes32, uint256, address, uint256) external pure returns (address) {
        return address(0xBeef);
    }
    function createAccount(address, bytes32, uint256, address, uint256) external pure returns (address) {
        return address(0xBeef);
    }
}

contract LogisticsFactoryTest is Test {
    LogisticsFactory public factory;
    MockRegistry public registry;

    function setUp() public {
        registry = new MockRegistry();
        factory = new LogisticsFactory(
            address(registry),
            address(0xCafe),
            1
        );
    }

    function test_deployZone() public {
        bytes32 zoneId = keccak256("agency1");
        bytes32 salt = keccak256("salt1");
        address zone = factory.deployZone(zoneId, "agency1", salt);
        assertTrue(zone != address(0));
        assertEq(LogisticsZone(zone).zoneId(), zoneId);
        assertEq(LogisticsZone(zone).tenantId(), "agency1");
        assertEq(LaborerNFT(LogisticsZone(zone).laborerNFT()).zoneId(), zoneId);
        assertEq(OrderNFT(LogisticsZone(zone).orderNFT()).zoneId(), zoneId);
        assertEq(JobSBT(LogisticsZone(zone).jobSBT()).zoneId(), zoneId);
    }

    function test_predictZoneAddress() public {
        bytes32 salt = keccak256("salt1");
        address predicted = factory.predictZoneAddress(salt);
        address actual = factory.deployZone(keccak256("agency1"), "agency1", salt);
        assertEq(predicted, actual);
    }
}
