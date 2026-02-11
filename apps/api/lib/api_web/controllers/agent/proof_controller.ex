defmodule ApiWeb.Agent.ProofController do
  @moduledoc """
  Agent API: submit proof of work or ZK proof of identity.
  In production this would validate and relay to chain (e.g. attestJob).
  """
  use ApiWeb, :controller

  def create(conn, %{"order_token_id" => order_id, "laborer_token_id" => laborer_id, "proof_data" => proof_data}) do
    zone_address = conn.assigns[:zone_address]
    proof_type = conn.params["proof_type"] || "signature"

    if is_nil(zone_address) do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Tenant/zone not resolved"})
    else
      # Placeholder: persist or relay to chain; then broadcast via PubSub.
      Phoenix.PubSub.broadcast(
        Api.PubSub,
        "zone:#{zone_address}",
        {:proof_submitted, %{order_token_id: order_id, laborer_token_id: laborer_id, proof_type: proof_type}}
      )
      json(conn, %{accepted: true, message: "Proof submitted for relay"})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Missing order_token_id, laborer_token_id, or proof_data"})
  end
end
