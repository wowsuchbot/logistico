defmodule ApiWeb.Agent.ZoneController do
  @moduledoc """
  Agent API: show current zone info (address, tenant_id).
  """
  use ApiWeb, :controller

  def show(conn, _params) do
    tenant_id = conn.assigns[:tenant_id]
    zone_address = conn.assigns[:zone_address]

    json(conn, %{
      tenant_id: tenant_id,
      zone_address: zone_address,
      message: "Use zone_address for chain calls; TBA funds via ERC-4337 relayers when configured"
    })
  end
end
