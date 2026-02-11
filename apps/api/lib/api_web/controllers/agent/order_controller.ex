defmodule ApiWeb.Agent.OrderController do
  @moduledoc """
  Agent API: list available orders in the resolved zone.
  """
  use ApiWeb, :controller

  def index(conn, _params) do
    tenant_id = conn.assigns[:tenant_id]
    zone_address = conn.assigns[:zone_address]

    if is_nil(tenant_id) || is_nil(zone_address) do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Tenant not resolved. Use subdomain e.g. agency1.vsaas.io"})
    else
      # In production: query indexer state or chain for available orders in zone.
      orders = Api.JobWatcher.available_orders(zone_address)
      json(conn, %{zone_id: tenant_id, orders: orders})
    end
  end
end
