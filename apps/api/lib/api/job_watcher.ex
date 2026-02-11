defmodule Api.JobWatcher do
  @moduledoc """
  GenServer that watches a single LogisticsZone contract for JobStarted, JobAttested, JobCompleted.
  Fetches logs via JSON-RPC and broadcasts to Phoenix.PubSub for real-time consumers.
  """
  use GenServer

  require Logger

  def start_link(opts) do
    zone_address = Keyword.fetch!(opts, :zone_address)
    tenant_id = Keyword.get(opts, :tenant_id, zone_address)
    GenServer.start_link(__MODULE__, %{zone_address: zone_address, tenant_id: tenant_id}, name: via_tuple(zone_address))
  end

  def available_orders(zone_address) do
    GenServer.call(via_tuple(zone_address), :available_orders, 5_000)
  end

  def via_tuple(zone_address) do
    {:via, Registry, {Api.JobWatcher.Registry, zone_address}}
  end

  @impl true
  def init(state) do
    Api.ZoneRegistry.register(state.tenant_id, state.zone_address)
    schedule_poll()
    {:ok, Map.put(state, :last_block, nil)}
  end

  @impl true
  def handle_info(:poll, state) do
    case fetch_events(state) do
      {:ok, events, new_block} ->
        for event <- events do
          Phoenix.PubSub.broadcast(Api.PubSub, "zone:#{state.zone_address}", {:job_event, event})
        end
        schedule_poll()
        {:noreply, %{state | last_block: new_block}}
      _ ->
        schedule_poll()
        {:noreply, state}
    end
  end

  def handle_call(:available_orders, _from, state) do
    # Placeholder: return from in-memory state or RPC; for now empty list.
    {:reply, [], state}
  end

  defp schedule_poll do
    Process.send_after(self(), :poll, 12_000)
  end

  defp fetch_events(state) do
    rpc_url = Application.get_env(:api, :rpc_url)
    if is_nil(rpc_url) or rpc_url == "" do
      {:ok, [], state.last_block}
    else
      # JSON-RPC eth_getLogs for LogisticsZone JobStarted, JobAttested, JobCompleted
      # Topic hashes and ABI would come from shared package or config.
      {:ok, [], state.last_block}
    end
  end
end
