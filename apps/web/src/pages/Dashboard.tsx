import type { Component } from "solid-js";

const Dashboard: Component = () => {
  return (
    <div>
      <h1>Fleet Dashboard</h1>
      <div class="card">
        <h2>Zone</h2>
        <p>Tenant is resolved via subdomain (e.g. agency1.vsaas.io). Configure API base URL for this app.</p>
      </div>
      <div class="card">
        <h2>Agent Economy</h2>
        <p>Bot Laborers use the Agent API to query orders and submit proof. Job SBTs accrue to Laborer TBAs.</p>
      </div>
    </div>
  );
};

export default Dashboard;
