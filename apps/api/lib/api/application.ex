defmodule Api.Application do
  @moduledoc """
  Application entry point. Starts PubSub and the JobWatcher supervision tree.
  """
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Api.PubSub},
      {Registry, keys: :unique, name: Api.JobWatcher.Registry},
      Api.ZoneRegistry,
      ApiWeb.Endpoint,
      Api.JobWatcher.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
