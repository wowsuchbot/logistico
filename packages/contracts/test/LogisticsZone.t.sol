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

contract LogisticsZoneTest is Test {
    LogisticsFactory public factory;
    MockRegistry public registry;
    address public zoneAddress;
    LogisticsZone public zone;
    address public alice = address(0xA11ce);
    address public bob = address(0xB0b);

    function setUp() public {
        registry = new MockRegistry();
        factory = new LogisticsFactory(
            address(registry),
            address(0xCafe),
            1
        );
        bytes32 zoneId = keccak256("agency1");
        bytes32 salt = keccak256("salt1");
        zoneAddress = factory.deployZone(zoneId, "agency1", salt);
        zone = LogisticsZone(zoneAddress);
    }

    function _mintLaborerAndOrder() internal {
        address laborerNft = zone.laborerNFT();
        address orderNft = zone.orderNFT();
        vm.startPrank(address(factory));
        LaborerNFT(laborerNft).mint(alice, 1);
        OrderNFT(orderNft).mint(alice, 1);
        vm.stopPrank();
    }

    function test_zoneOwnerIsFactory() public view {
        assertEq(zone.zoneOwner(), address(factory));
    }

    function test_fullJobLifecycle() public {
        _mintLaborerAndOrder();
        vm.prank(address(factory));
        zone.setOrderAvailable(1);

        vm.prank(alice);
        zone.startJob(1, 1);
        assertEq(uint256(zone.orderStatus(1)), uint256(LogisticsZone.OrderStatus.Started));
        assertEq(zone.orderToLaborer(1), 1);

        zone.attestJob(1, 1, "");
        assertEq(uint256(zone.orderStatus(1)), uint256(LogisticsZone.OrderStatus.Attested));

        zone.completeJob(1, 1);
        assertEq(uint256(zone.orderStatus(1)), uint256(LogisticsZone.OrderStatus.Completed));
        assertEq(zone.jobCounter(), 1);

        address laborerTBA = LaborerNFT(zone.laborerNFT()).getTBA(1);
        assertEq(laborerTBA, address(0xBeef));
        assertEq(JobSBT(zone.jobSBT()).ownerOf(1), address(0xBeef));
    }

    function test_startJobRevertsWhenOrderNotAvailable() public {
        _mintLaborerAndOrder();
        vm.prank(alice);
        vm.expectRevert("LogisticsZone: order not available");
        zone.startJob(1, 1);
    }

    function test_startJobRevertsWhenNotOrderOwner() public {
        _mintLaborerAndOrder();
        vm.prank(address(factory));
        zone.setOrderAvailable(1);
        vm.prank(bob);
        vm.expectRevert("LogisticsZone: not order owner");
        zone.startJob(1, 1);
    }

    function test_attestJobRevertsWhenNotStarted() public {
        _mintLaborerAndOrder();
        vm.expectRevert("LogisticsZone: order not started");
        zone.attestJob(1, 1, "");
    }

    function test_attestJobRevertsWhenWrongLaborer() public {
        _mintLaborerAndOrder();
        vm.prank(address(factory));
        zone.setOrderAvailable(1);
        vm.prank(alice);
        zone.startJob(1, 1);
        vm.expectRevert("LogisticsZone: laborer mismatch");
        zone.attestJob(1, 999, "");
    }

    function test_completeJobRevertsWhenNotAttested() public {
        _mintLaborerAndOrder();
        vm.prank(address(factory));
        zone.setOrderAvailable(1);
        vm.prank(alice);
        zone.startJob(1, 1);
        vm.expectRevert("LogisticsZone: order not attested");
        zone.completeJob(1, 1);
    }

    function test_setOrderAvailableRevertsWhenNotZoneOwner() public {
        _mintLaborerAndOrder();
        vm.prank(alice);
        vm.expectRevert("LogisticsZone: not zone owner");
        zone.setOrderAvailable(1);
    }

    function test_zoneOwnerCanStartJobForAnyOrder() public {
        _mintLaborerAndOrder();
        vm.prank(address(factory));
        zone.setOrderAvailable(1);
        vm.prank(address(factory));
        zone.startJob(1, 1);
        assertEq(uint256(zone.orderStatus(1)), uint256(LogisticsZone.OrderStatus.Started));
    }

    function test_jobSBT_SoulboundTransferReverts() public {
        _mintLaborerAndOrder();
        vm.prank(address(factory));
        zone.setOrderAvailable(1);
        vm.prank(alice);
        zone.startJob(1, 1);
        zone.attestJob(1, 1, "");
        zone.completeJob(1, 1);

        address jobSbt = zone.jobSBT();
        vm.prank(address(0xBeef));
        vm.expectRevert("JobSBT: soulbound, cannot transfer");
        JobSBT(jobSbt).transferFrom(address(0xBeef), bob, 1);
    }

    function test_laborerNFT_getTBA() public view {
        assertEq(LaborerNFT(zone.laborerNFT()).getTBA(1), address(0xBeef));
    }

    function test_laborerNFT_setZkProofCommitment_asOwner() public {
        _mintLaborerAndOrder();
        bytes32 commitment = keccak256("zk-proof");
        address laborerNft = zone.laborerNFT();
        vm.prank(alice);
        LaborerNFT(laborerNft).setZkProofCommitment(1, commitment);
        assertEq(LaborerNFT(laborerNft).zkProofCommitment(1), commitment);
    }
}
