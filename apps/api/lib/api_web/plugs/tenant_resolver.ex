defmodule ApiWeb.Plugs.TenantResolver do
  @moduledoc """
  Resolves tenant from request host (subdomain).
  Expects host like `agency1.vsaas.io` and assigns `tenant_id` and optionally `zone_address` to the conn.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    suffix = Application.get_env(:api, :tenant_domain_suffix, ".vsaas.io")
    host = get_req_header(conn, "host") |> List.first() || conn.host

    tenant_id = extract_tenant_from_host(host, suffix)
    conn
    |> assign(:tenant_id, tenant_id)
    |> assign(:zone_address, zone_address_for_tenant(tenant_id))
  end

  defp extract_tenant_from_host(host, suffix) do
    case String.split(host, suffix, parts: 2) do
      [sub, ""] when sub != "" -> String.downcase(sub)
      _ -> nil
    end
  end

  defp zone_address_for_tenant(nil), do: nil

  defp zone_address_for_tenant(tenant_id) do
    # Resolve zone contract address from tenant_id (e.g. from registry/cache started by JobWatcher).
    case Api.ZoneRegistry.lookup(tenant_id) do
      {:ok, address} -> address
      _ -> nil
    end
  end
end
