defmodule Api.ZoneRegistry do
  @moduledoc """
  In-memory registry of tenant_id -> zone contract address.
  Populated when JobWatcher starts for a zone (e.g. from Factory events or config).
  """
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def lookup(tenant_id) do
    case Process.whereis(__MODULE__) do
      nil -> :error
      _ ->
        map = Agent.get(__MODULE__, & &1)
        case Map.get(map, tenant_id) do
          nil -> :error
          addr -> {:ok, addr}
        end
    end
  end

  def register(tenant_id, zone_address) do
    Agent.update(__MODULE__, &Map.put(&1, tenant_id, zone_address))
    :ok
  end
end
