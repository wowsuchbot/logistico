defmodule ApiWeb.HealthController do
  use ApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "ok", tenant_id: conn.assigns[:tenant_id]})
  end
end
