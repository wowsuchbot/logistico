defmodule ApiWeb.UserSocket do
  use Phoenix.Socket

  channel "zone:*", ApiWeb.ZoneChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(socket), do: nil
end
