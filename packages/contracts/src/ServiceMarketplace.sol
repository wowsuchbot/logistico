// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title ServiceMarketplace
 * @notice Global marketplace for goods and services with optional zone restrictions
 * @dev Enables services to be listed as GLOBAL (worldwide), REGIONAL (multi-zone), or LOCAL (zone-specific)
 * 
 * Key Features:
 * - Three service scopes: GLOBAL, REGIONAL, LOCAL
 * - Optional zone binding for location-based services
 * - Category-based service discovery
 * - Provider reputation integration
 * - Escrow-based payment protection
 * 
 * Example Use Cases:
 * - GLOBAL: Designer offering branding services worldwide
 * - REGIONAL: Consultant serving specific geographic zones
 * - LOCAL: Food delivery within a single zone (original Logistico behavior)
 */
contract ServiceMarketplace is Ownable, ReentrancyGuard {
    
    // ============ Enums ============
    
    enum ServiceScope {
        GLOBAL,      // Available worldwide, no zone restrictions
        REGIONAL,    // Available in specific zones only
        LOCAL        // Single zone only (original zone-based behavior)
    }
    
    enum ServiceStatus {
        Active,
        Paused,
        Completed,
        Cancelled
    }
    
    enum TransactionStatus {
        Pending,
        InProgress,
        Completed,
        Disputed,
        Cancelled,
        Refunded
    }
    
    // ============ Structs ============
    
    struct Service {
        uint256 serviceId;
        address provider;
        ServiceScope scope;
        string title;
        string description;
        string category;
        uint256 priceInWei;        // Fixed price in Wei (ETH)
        bool isHourlyRate;         // true = hourly rate, false = fixed price
        ServiceStatus status;
        uint256 createdAt;
        uint256 completedCount;
        uint256[] allowedZoneIds;  // Empty for GLOBAL, populated for REGIONAL/LOCAL
        string metadataURI;        // IPFS hash for portfolio, images, detailed info
    }
    
    struct ServiceTransaction {
        uint256 transactionId;
        uint256 serviceId;
        address buyer;
        address provider;
        uint256 amountInWei;
        TransactionStatus status;
        uint256 createdAt;
        uint256 completedAt;
        string deliveryProofURI;   // IPFS hash for delivery proof
    }
    
    // ============ State Variables ============
    
    uint256 private _nextServiceId = 1;
    uint256 private _nextTransactionId = 1;
    
    // Service storage
    mapping(uint256 => Service) public services;
    mapping(address => uint256[]) public providerServices;
    
    // Transaction storage
    mapping(uint256 => ServiceTransaction) public transactions;
    mapping(uint256 => uint256[]) public serviceTransactions; // serviceId => transactionIds
    
    // Category management
    mapping(string => bool) public validCategories;
    string[] public categoryList;
    
    // Zone integration
    mapping(uint256 => address) public zoneContracts; // zoneId => LogisticsZone address
    
    // Platform fee (basis points, e.g., 250 = 2.5%)
    uint256 public platformFeeBps = 250;
    address public feeRecipient;
    
    // ============ Events ============
    
    event ServiceCreated(
        uint256 indexed serviceId,
        address indexed provider,
        ServiceScope scope,
        string category,
        uint256 priceInWei
    );
    
    event ServiceUpdated(
        uint256 indexed serviceId,
        ServiceStatus status,
        uint256 priceInWei
    );
    
    event TransactionCreated(
        uint256 indexed transactionId,
        uint256 indexed serviceId,
        address indexed buyer,
        address provider,
        uint256 amountInWei
    );
    
    event TransactionCompleted(
        uint256 indexed transactionId,
        uint256 indexed serviceId,
        string deliveryProofURI
    );
    
    event TransactionCancelled(
        uint256 indexed transactionId,
        uint256 indexed serviceId,
        address initiator
    );
    
    event CategoryAdded(string category);
    event ZoneRegistered(uint256 indexed zoneId, address zoneContract);
    event PlatformFeeUpdated(uint256 oldFeeBps, uint256 newFeeBps);
    
    // ============ Modifiers ============
    
    modifier onlyServiceProvider(uint256 serviceId) {
        require(services[serviceId].provider == msg.sender, "Not service provider");
        _;
    }
    
    modifier serviceExists(uint256 serviceId) {
        require(serviceId > 0 && serviceId < _nextServiceId, "Service does not exist");
        _;
    }
    
    modifier transactionExists(uint256 transactionId) {
        require(transactionId > 0 && transactionId < _nextTransactionId, "Transaction does not exist");
        _;
    }
    
    // ============ Constructor ============
    
    constructor() Ownable(msg.sender) {
        feeRecipient = msg.sender;
        
        // Initialize default categories
        _addCategory("Design & Creative");
        _addCategory("Development & Tech");
        _addCategory("Consulting & Strategy");
        _addCategory("Writing & Content");
        _addCategory("Marketing & Sales");
        _addCategory("Delivery & Logistics");
        _addCategory("Education & Tutoring");
        _addCategory("Personal Services");
        _addCategory("Physical Products");
        _addCategory("Digital Products");
    }
    
    // ============ Service Management Functions ============
    
    /**
     * @notice Create a new service listing
     * @param scope Service scope (GLOBAL, REGIONAL, or LOCAL)
     * @param title Service title
     * @param description Service description
     * @param category Service category (must be valid)
     * @param priceInWei Price in Wei
     * @param isHourlyRate True if price is hourly rate, false if fixed price
     * @param allowedZoneIds Zone IDs for REGIONAL/LOCAL services (empty for GLOBAL)
     * @param metadataURI IPFS URI for additional metadata
     * @return serviceId The ID of the created service
     */
    function createService(
        ServiceScope scope,
        string memory title,
        string memory description,
        string memory category,
        uint256 priceInWei,
        bool isHourlyRate,
        uint256[] memory allowedZoneIds,
        string memory metadataURI
    ) external returns (uint256) {
        require(bytes(title).length > 0, "Title required");
        require(bytes(description).length > 0, "Description required");
        require(validCategories[category], "Invalid category");
        require(priceInWei > 0, "Price must be greater than 0");
        
        // Validate zone restrictions based on scope
        if (scope == ServiceScope.GLOBAL) {
            require(allowedZoneIds.length == 0, "GLOBAL services cannot have zone restrictions");
        } else if (scope == ServiceScope.LOCAL) {
            require(allowedZoneIds.length == 1, "LOCAL services must have exactly 1 zone");
        } else {
            require(allowedZoneIds.length > 0, "REGIONAL services must have at least 1 zone");
        }
        
        uint256 serviceId = _nextServiceId++;
        
        Service storage newService = services[serviceId];
        newService.serviceId = serviceId;
        newService.provider = msg.sender;
        newService.scope = scope;
        newService.title = title;
        newService.description = description;
        newService.category = category;
        newService.priceInWei = priceInWei;
        newService.isHourlyRate = isHourlyRate;
        newService.status = ServiceStatus.Active;
        newService.createdAt = block.timestamp;
        newService.completedCount = 0;
        newService.allowedZoneIds = allowedZoneIds;
        newService.metadataURI = metadataURI;
        
        providerServices[msg.sender].push(serviceId);
        
        emit ServiceCreated(serviceId, msg.sender, scope, category, priceInWei);
        
        return serviceId;
    }
    
    /**
     * @notice Update service status or price
     * @param serviceId The service ID to update
     * @param status New service status
     * @param priceInWei New price (0 to keep current price)
     */
    function updateService(
        uint256 serviceId,
        ServiceStatus status,
        uint256 priceInWei
    ) external serviceExists(serviceId) onlyServiceProvider(serviceId) {
        Service storage service = services[serviceId];
        
        service.status = status;
        
        if (priceInWei > 0) {
            service.priceInWei = priceInWei;
        }
        
        emit ServiceUpdated(serviceId, status, service.priceInWei);
    }
    
    // ============ Transaction Functions ============
    
    /**
     * @notice Purchase a service (buyer pays upfront, held in escrow)
     * @param serviceId The service to purchase
     * @param zoneId The zone where service will be delivered (0 for GLOBAL services)
     * @return transactionId The ID of the created transaction
     */
    function purchaseService(
        uint256 serviceId,
        uint256 zoneId
    ) external payable serviceExists(serviceId) nonReentrant returns (uint256) {
        Service storage service = services[serviceId];
        
        require(service.status == ServiceStatus.Active, "Service not active");
        require(msg.value == service.priceInWei, "Incorrect payment amount");
        
        // Validate zone access for non-GLOBAL services
        if (service.scope != ServiceScope.GLOBAL) {
            bool zoneAllowed = false;
            for (uint256 i = 0; i < service.allowedZoneIds.length; i++) {
                if (service.allowedZoneIds[i] == zoneId) {
                    zoneAllowed = true;
                    break;
                }
            }
            require(zoneAllowed, "Service not available in this zone");
        }
        
        uint256 transactionId = _nextTransactionId++;
        
        ServiceTransaction storage txn = transactions[transactionId];
        txn.transactionId = transactionId;
        txn.serviceId = serviceId;
        txn.buyer = msg.sender;
        txn.provider = service.provider;
        txn.amountInWei = msg.value;
        txn.status = TransactionStatus.Pending;
        txn.createdAt = block.timestamp;
        
        serviceTransactions[serviceId].push(transactionId);
        
        emit TransactionCreated(transactionId, serviceId, msg.sender, service.provider, msg.value);
        
        return transactionId;
    }
    
    /**
     * @notice Provider marks service as in progress
     * @param transactionId The transaction ID
     */
    function startServiceDelivery(uint256 transactionId) 
        external 
        transactionExists(transactionId) 
    {
        ServiceTransaction storage txn = transactions[transactionId];
        require(txn.provider == msg.sender, "Not the provider");
        require(txn.status == TransactionStatus.Pending, "Invalid status");
        
        txn.status = TransactionStatus.InProgress;
    }
    
    /**
     * @notice Complete a service transaction and release payment
     * @param transactionId The transaction ID
     * @param deliveryProofURI IPFS URI with proof of delivery/completion
     */
    function completeService(
        uint256 transactionId,
        string memory deliveryProofURI
    ) external transactionExists(transactionId) nonReentrant {
        ServiceTransaction storage txn = transactions[transactionId];
        
        require(txn.provider == msg.sender, "Not the provider");
        require(
            txn.status == TransactionStatus.InProgress || 
            txn.status == TransactionStatus.Pending,
            "Invalid status"
        );
        
        txn.status = TransactionStatus.Completed;
        txn.completedAt = block.timestamp;
        txn.deliveryProofURI = deliveryProofURI;
        
        // Update service completion count
        Service storage service = services[txn.serviceId];
        service.completedCount++;
        
        // Calculate platform fee and provider payment
        uint256 platformFee = (txn.amountInWei * platformFeeBps) / 10000;
        uint256 providerPayment = txn.amountInWei - platformFee;
        
        // Transfer funds
        if (platformFee > 0) {
            (bool feeSuccess, ) = feeRecipient.call{value: platformFee}("");
            require(feeSuccess, "Fee transfer failed");
        }
        
        (bool providerSuccess, ) = txn.provider.call{value: providerPayment}("");
        require(providerSuccess, "Provider payment failed");
        
        emit TransactionCompleted(transactionId, txn.serviceId, deliveryProofURI);
    }
    
    /**
     * @notice Cancel a transaction (before service starts)
     * @param transactionId The transaction ID
     */
    function cancelTransaction(uint256 transactionId) 
        external 
        transactionExists(transactionId) 
        nonReentrant 
    {
        ServiceTransaction storage txn = transactions[transactionId];
        
        require(
            msg.sender == txn.buyer || msg.sender == txn.provider,
            "Not authorized"
        );
        require(txn.status == TransactionStatus.Pending, "Can only cancel pending transactions");
        
        txn.status = TransactionStatus.Cancelled;
        
        // Refund buyer
        (bool success, ) = txn.buyer.call{value: txn.amountInWei}("");
        require(success, "Refund failed");
        
        emit TransactionCancelled(transactionId, txn.serviceId, msg.sender);
    }
    
    // ============ View Functions ============
    
    /**
     * @notice Get service details
     * @param serviceId The service ID
     * @return Service struct
     */
    function getService(uint256 serviceId) 
        external 
        view 
        serviceExists(serviceId) 
        returns (Service memory) 
    {
        return services[serviceId];
    }
    
    /**
     * @notice Get all services by a provider
     * @param provider Provider address
     * @return Array of service IDs
     */
    function getProviderServices(address provider) 
        external 
        view 
        returns (uint256[] memory) 
    {
        return providerServices[provider];
    }
    
    /**
     * @notice Get transaction details
     * @param transactionId The transaction ID
     * @return ServiceTransaction struct
     */
    function getTransaction(uint256 transactionId) 
        external 
        view 
        transactionExists(transactionId) 
        returns (ServiceTransaction memory) 
    {
        return transactions[transactionId];
    }
    
    /**
     * @notice Get all transactions for a service
     * @param serviceId The service ID
     * @return Array of transaction IDs
     */
    function getServiceTransactions(uint256 serviceId) 
        external 
        view 
        serviceExists(serviceId) 
        returns (uint256[] memory) 
    {
        return serviceTransactions[serviceId];
    }
    
    /**
     * @notice Get all valid categories
     * @return Array of category names
     */
    function getCategories() external view returns (string[] memory) {
        return categoryList;
    }
    
    /**
     * @notice Check if service is available in a zone
     * @param serviceId The service ID
     * @param zoneId The zone ID (0 for global check)
     * @return bool True if available
     */
    function isServiceAvailableInZone(uint256 serviceId, uint256 zoneId) 
        external 
        view 
        serviceExists(serviceId) 
        returns (bool) 
    {
        Service storage service = services[serviceId];
        
        if (service.scope == ServiceScope.GLOBAL) {
            return true;
        }
        
        for (uint256 i = 0; i < service.allowedZoneIds.length; i++) {
            if (service.allowedZoneIds[i] == zoneId) {
                return true;
            }
        }
        
        return false;
    }
    
    // ============ Admin Functions ============
    
    /**
     * @notice Add a new service category
     * @param category Category name
     */
    function addCategory(string memory category) external onlyOwner {
        _addCategory(category);
    }
    
    function _addCategory(string memory category) private {
        require(!validCategories[category], "Category already exists");
        validCategories[category] = true;
        categoryList.push(category);
        emit CategoryAdded(category);
    }
    
    /**
     * @notice Register a zone contract for integration
     * @param zoneId Zone ID
     * @param zoneContract LogisticsZone contract address
     */
    function registerZone(uint256 zoneId, address zoneContract) external onlyOwner {
        require(zoneContract != address(0), "Invalid zone contract");
        zoneContracts[zoneId] = zoneContract;
        emit ZoneRegistered(zoneId, zoneContract);
    }
    
    /**
     * @notice Update platform fee
     * @param newFeeBps New fee in basis points (e.g., 250 = 2.5%)
     */
    function setPlatformFee(uint256 newFeeBps) external onlyOwner {
        require(newFeeBps <= 1000, "Fee cannot exceed 10%");
        uint256 oldFee = platformFeeBps;
        platformFeeBps = newFeeBps;
        emit PlatformFeeUpdated(oldFee, newFeeBps);
    }
    
    /**
     * @notice Update fee recipient address
     * @param newRecipient New fee recipient
     */
    function setFeeRecipient(address newRecipient) external onlyOwner {
        require(newRecipient != address(0), "Invalid recipient");
        feeRecipient = newRecipient;
    }
}
