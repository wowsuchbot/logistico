defmodule Api.JobWatcher.Supervisor do
  @moduledoc """
  DynamicSupervisor: one JobWatcher GenServer per known LogisticsZone address.
  Zones can be added at runtime (e.g. when Factory emits ZoneDeployed or from config).
  """
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(zone_address, opts \\ []) do
    spec = {Api.JobWatcher, [zone_address: zone_address] ++ opts}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_child(zone_address) do
    case Registry.lookup(Api.JobWatcher.Registry, zone_address) do
      [{pid, _}] -> DynamicSupervisor.terminate_child(__MODULE__, pid)
      [] -> {:error, :not_found}
    end
  end
end
