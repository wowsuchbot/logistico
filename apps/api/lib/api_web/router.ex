defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ApiWeb.Plugs.TenantResolver
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get "/health", HealthController, :index

    scope "/agent", Agent do
      get "/orders", OrderController, :index
      post "/proof", ProofController, :create
      get "/zone", ZoneController, :show
    end
  end
end
