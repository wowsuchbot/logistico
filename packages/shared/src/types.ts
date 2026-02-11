/**
 * Shared types for Logistics vSaaS (API, Web, indexer).
 */

export type TenantId = string;

export type ZoneId = string; // bytes32 hex

export type OrderStatus = "none" | "available" | "started" | "attested" | "completed";

export interface Zone {
  zoneId: ZoneId;
  tenantId: TenantId;
  address: string;
  laborerNFT: string;
  orderNFT: string;
  jobSBT: string;
}

export interface Laborer {
  tokenId: string;
  zoneId: ZoneId;
  owner: string;
  tba: string;
  zkProofCommitment?: string; // bytes32 hex
}

export interface Order {
  tokenId: string;
  zoneId: ZoneId;
  owner: string;
  tba: string;
  status: OrderStatus;
  laborerTokenId?: string;
}

export interface JobSBT {
  jobId: string;
  zoneId: ZoneId;
  ownerTba: string;
}

/** Agent API: proof of work / ZK identity submission */
export interface ProofSubmission {
  orderTokenId: string;
  laborerTokenId: string;
  proofData: string; // hex or base64
  proofType?: "zk" | "signature" | "attestation";
}

/** Agent API: available orders query response */
export interface AvailableOrdersResponse {
  zoneId: ZoneId;
  orders: Order[];
  cursor?: string;
}
