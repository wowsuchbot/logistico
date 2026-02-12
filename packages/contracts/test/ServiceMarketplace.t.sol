// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/ServiceMarketplace.sol";

/**
 * @title ServiceMarketplaceTest
 * @notice Comprehensive test suite for ServiceMarketplace contract
 */
contract ServiceMarketplaceTest is Test {
    ServiceMarketplace public marketplace;
    
    address public owner = address(1);
    address public provider1 = address(2);
    address public provider2 = address(3);
    address public buyer1 = address(4);
    address public buyer2 = address(5);
    
    uint256 constant PRICE_1_ETH = 1 ether;
    uint256 constant PRICE_0_5_ETH = 0.5 ether;
    
    function setUp() public {
        vm.prank(owner);
        marketplace = new ServiceMarketplace();
        
        // Fund test accounts
        vm.deal(buyer1, 10 ether);
        vm.deal(buyer2, 10 ether);
    }
    
    // ============ Service Creation Tests ============
    
    function testCreateGlobalService() public {
        vm.startPrank(provider1);
        
        uint256[] memory emptyZones = new uint256[](0);
        
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Brand Design Services",
            "Professional branding and logo design",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            "ipfs://metadata123"
        );
        
        assertEq(serviceId, 1);
        
        ServiceMarketplace.Service memory service = marketplace.getService(serviceId);
        assertEq(service.provider, provider1);
        assertEq(uint(service.scope), uint(ServiceMarketplace.ServiceScope.GLOBAL));
        assertEq(service.priceInWei, PRICE_1_ETH);
        assertEq(service.allowedZoneIds.length, 0);
        
        vm.stopPrank();
    }
    
    function testCreateRegionalService() public {
        vm.startPrank(provider1);
        
        uint256[] memory zones = new uint256[](3);
        zones[0] = 1;
        zones[1] = 2;
        zones[2] = 3;
        
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.REGIONAL,
            "Business Consulting",
            "Strategic business consulting for North America",
            "Consulting & Strategy",
            PRICE_1_ETH,
            true, // hourly rate
            zones,
            "ipfs://metadata456"
        );
        
        ServiceMarketplace.Service memory service = marketplace.getService(serviceId);
        assertEq(uint(service.scope), uint(ServiceMarketplace.ServiceScope.REGIONAL));
        assertEq(service.allowedZoneIds.length, 3);
        assertTrue(service.isHourlyRate);
        
        vm.stopPrank();
    }
    
    function testCreateLocalService() public {
        vm.startPrank(provider1);
        
        uint256[] memory zones = new uint256[](1);
        zones[0] = 5;
        
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.LOCAL,
            "Food Delivery",
            "Fast food delivery in downtown",
            "Delivery & Logistics",
            PRICE_0_5_ETH,
            false,
            zones,
            "ipfs://metadata789"
        );
        
        ServiceMarketplace.Service memory service = marketplace.getService(serviceId);
        assertEq(uint(service.scope), uint(ServiceMarketplace.ServiceScope.LOCAL));
        assertEq(service.allowedZoneIds.length, 1);
        assertEq(service.allowedZoneIds[0], 5);
        
        vm.stopPrank();
    }
    
    function testFailCreateGlobalWithZones() public {
        vm.startPrank(provider1);
        
        uint256[] memory zones = new uint256[](1);
        zones[0] = 1;
        
        // Should fail: GLOBAL services cannot have zone restrictions
        marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Test Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            zones,
            ""
        );
        
        vm.stopPrank();
    }
    
    function testFailCreateLocalWithMultipleZones() public {
        vm.startPrank(provider1);
        
        uint256[] memory zones = new uint256[](2);
        zones[0] = 1;
        zones[1] = 2;
        
        // Should fail: LOCAL services must have exactly 1 zone
        marketplace.createService(
            ServiceMarketplace.ServiceScope.LOCAL,
            "Test Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            zones,
            ""
        );
        
        vm.stopPrank();
    }
    
    function testFailCreateWithInvalidCategory() public {
        vm.startPrank(provider1);
        
        uint256[] memory emptyZones = new uint256[](0);
        
        // Should fail: Invalid category
        marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Test Service",
            "Description",
            "Invalid Category",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        vm.stopPrank();
    }
    
    // ============ Service Update Tests ============
    
    function testUpdateService() public {
        // Create service first
        vm.startPrank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Test Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        // Update price and status
        marketplace.updateService(
            serviceId,
            ServiceMarketplace.ServiceStatus.Paused,
            2 ether
        );
        
        ServiceMarketplace.Service memory service = marketplace.getService(serviceId);
        assertEq(uint(service.status), uint(ServiceMarketplace.ServiceStatus.Paused));
        assertEq(service.priceInWei, 2 ether);
        
        vm.stopPrank();
    }
    
    function testFailUpdateServiceNotProvider() public {
        // Create service as provider1
        vm.prank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Test Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        // Try to update as provider2 (should fail)
        vm.prank(provider2);
        marketplace.updateService(
            serviceId,
            ServiceMarketplace.ServiceStatus.Paused,
            0
        );
    }
    
    // ============ Transaction Tests ============
    
    function testPurchaseGlobalService() public {
        // Create global service
        vm.prank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Design Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        // Purchase service
        vm.prank(buyer1);
        uint256 txId = marketplace.purchaseService{value: PRICE_1_ETH}(serviceId, 0);
        
        assertEq(txId, 1);
        
        ServiceMarketplace.ServiceTransaction memory txn = marketplace.getTransaction(txId);
        assertEq(txn.buyer, buyer1);
        assertEq(txn.provider, provider1);
        assertEq(txn.amountInWei, PRICE_1_ETH);
        assertEq(uint(txn.status), uint(ServiceMarketplace.TransactionStatus.Pending));
    }
    
    function testPurchaseRegionalServiceInAllowedZone() public {
        // Create regional service
        vm.prank(provider1);
        uint256[] memory zones = new uint256[](2);
        zones[0] = 1;
        zones[1] = 2;
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.REGIONAL,
            "Consulting",
            "Description",
            "Consulting & Strategy",
            PRICE_1_ETH,
            false,
            zones,
            ""
        );
        
        // Purchase in allowed zone
        vm.prank(buyer1);
        uint256 txId = marketplace.purchaseService{value: PRICE_1_ETH}(serviceId, 1);
        
        assertEq(txId, 1);
    }
    
    function testFailPurchaseRegionalServiceInDisallowedZone() public {
        // Create regional service
        vm.prank(provider1);
        uint256[] memory zones = new uint256[](2);
        zones[0] = 1;
        zones[1] = 2;
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.REGIONAL,
            "Consulting",
            "Description",
            "Consulting & Strategy",
            PRICE_1_ETH,
            false,
            zones,
            ""
        );
        
        // Try to purchase in zone 3 (not allowed)
        vm.prank(buyer1);
        marketplace.purchaseService{value: PRICE_1_ETH}(serviceId, 3);
    }
    
    function testFailPurchaseWithWrongAmount() public {
        // Create service
        vm.prank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        // Try to purchase with wrong amount
        vm.prank(buyer1);
        marketplace.purchaseService{value: 0.5 ether}(serviceId, 0);
    }
    
    function testCompleteServiceTransaction() public {
        // Create and purchase service
        vm.prank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Design Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        vm.prank(buyer1);
        uint256 txId = marketplace.purchaseService{value: PRICE_1_ETH}(serviceId, 0);
        
        // Record provider balance before
        uint256 providerBalanceBefore = provider1.balance;
        uint256 feeRecipientBalanceBefore = owner.balance;
        
        // Complete service
        vm.prank(provider1);
        marketplace.completeService(txId, "ipfs://deliveryproof");
        
        // Check transaction status
        ServiceMarketplace.ServiceTransaction memory txn = marketplace.getTransaction(txId);
        assertEq(uint(txn.status), uint(ServiceMarketplace.TransactionStatus.Completed));
        
        // Check payment distribution (2.5% platform fee)
        uint256 platformFee = (PRICE_1_ETH * 250) / 10000; // 0.025 ETH
        uint256 providerPayment = PRICE_1_ETH - platformFee; // 0.975 ETH
        
        assertEq(provider1.balance, providerBalanceBefore + providerPayment);
        assertEq(owner.balance, feeRecipientBalanceBefore + platformFee);
        
        // Check service completion count
        ServiceMarketplace.Service memory service = marketplace.getService(serviceId);
        assertEq(service.completedCount, 1);
    }
    
    function testCancelTransaction() public {
        // Create and purchase service
        vm.prank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Design Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        vm.prank(buyer1);
        uint256 buyerBalanceBefore = buyer1.balance;
        uint256 txId = marketplace.purchaseService{value: PRICE_1_ETH}(serviceId, 0);
        
        // Cancel transaction
        vm.prank(buyer1);
        marketplace.cancelTransaction(txId);
        
        // Check refund
        assertEq(buyer1.balance, buyerBalanceBefore);
        
        // Check transaction status
        ServiceMarketplace.ServiceTransaction memory txn = marketplace.getTransaction(txId);
        assertEq(uint(txn.status), uint(ServiceMarketplace.TransactionStatus.Cancelled));
    }
    
    function testStartServiceDelivery() public {
        // Create and purchase service
        vm.prank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Design Service",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        vm.prank(buyer1);
        uint256 txId = marketplace.purchaseService{value: PRICE_1_ETH}(serviceId, 0);
        
        // Start delivery
        vm.prank(provider1);
        marketplace.startServiceDelivery(txId);
        
        // Check status
        ServiceMarketplace.ServiceTransaction memory txn = marketplace.getTransaction(txId);
        assertEq(uint(txn.status), uint(ServiceMarketplace.TransactionStatus.InProgress));
    }
    
    // ============ View Function Tests ============
    
    function testGetProviderServices() public {
        vm.startPrank(provider1);
        uint256[] memory emptyZones = new uint256[](0);
        
        // Create multiple services
        uint256 serviceId1 = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Service 1",
            "Description",
            "Design & Creative",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        uint256 serviceId2 = marketplace.createService(
            ServiceMarketplace.ServiceScope.GLOBAL,
            "Service 2",
            "Description",
            "Development & Tech",
            PRICE_1_ETH,
            false,
            emptyZones,
            ""
        );
        
        vm.stopPrank();
        
        uint256[] memory providerServices = marketplace.getProviderServices(provider1);
        assertEq(providerServices.length, 2);
        assertEq(providerServices[0], serviceId1);
        assertEq(providerServices[1], serviceId2);
    }
    
    function testIsServiceAvailableInZone() public {
        vm.prank(provider1);
        uint256[] memory zones = new uint256[](2);
        zones[0] = 1;
        zones[1] = 2;
        uint256 serviceId = marketplace.createService(
            ServiceMarketplace.ServiceScope.REGIONAL,
            "Service",
            "Description",
            "Consulting & Strategy",
            PRICE_1_ETH,
            false,
            zones,
            ""
        );
        
        assertTrue(marketplace.isServiceAvailableInZone(serviceId, 1));
        assertTrue(marketplace.isServiceAvailableInZone(serviceId, 2));
        assertFalse(marketplace.isServiceAvailableInZone(serviceId, 3));
    }
    
    function testGetCategories() public {
        string[] memory categories = marketplace.getCategories();
        assertGt(categories.length, 0);
    }
    
    // ============ Admin Function Tests ============
    
    function testAddCategory() public {
        vm.prank(owner);
        marketplace.addCategory("New Category");
        
        string[] memory categories = marketplace.getCategories();
        bool found = false;
        for (uint i = 0; i < categories.length; i++) {
            if (keccak256(bytes(categories[i])) == keccak256(bytes("New Category"))) {
                found = true;
                break;
            }
        }
        assertTrue(found);
    }
    
    function testSetPlatformFee() public {
        vm.prank(owner);
        marketplace.setPlatformFee(500); // 5%
        
        assertEq(marketplace.platformFeeBps(), 500);
    }
    
    function testFailSetPlatformFeeTooHigh() public {
        vm.prank(owner);
        marketplace.setPlatformFee(1001); // Over 10%
    }
    
    function testRegisterZone() public {
        vm.prank(owner);
        marketplace.registerZone(1, address(0x123));
        
        assertEq(marketplace.zoneContracts(1), address(0x123));
    }
}
