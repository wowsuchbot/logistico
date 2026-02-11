defmodule ApiWeb.ZoneChannel do
  use Phoenix.Channel

  @impl true
  def join("zone:" <> zone_address, _params, socket) do
    Phoenix.PubSub.subscribe(Api.PubSub, "zone:#{zone_address}")
    {:ok, socket}
  end
end
