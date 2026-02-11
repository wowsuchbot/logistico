export const LogisticsFactoryAbi = [
  {
    type: "event",
    name: "ZoneDeployed",
    inputs: [
      { name: "zoneId", type: "bytes32", indexed: true },
      { name: "tenantId", type: "string", indexed: false },
      { name: "zoneAddress", type: "address", indexed: true },
      { name: "deployedBy", type: "address", indexed: true },
    ],
  },
  {
    type: "function",
    name: "deployZone",
    inputs: [
      { name: "zoneId_", type: "bytes32" },
      { name: "tenantId_", type: "string" },
      { name: "salt", type: "bytes32" },
    ],
    outputs: [{ name: "zone", type: "address" }],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "predictZoneAddress",
    inputs: [{ name: "salt", type: "bytes32" }],
    outputs: [{ name: "", type: "address" }],
    stateMutability: "view",
  },
] as const;
