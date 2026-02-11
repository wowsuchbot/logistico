import type { Component } from "solid-js";

const Orders: Component = () => {
  return (
    <div>
      <h1>Orders</h1>
      <div class="card">
        <h2>Order NFTs</h2>
        <p>Orders are ERC-721 with ERC-6551 TBA holding escrow. List and status come from the API indexer.</p>
      </div>
    </div>
  );
};

export default Orders;
