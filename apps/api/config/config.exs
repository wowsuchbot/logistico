import Config

config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: Api.PubSub,
  secret_key_base: "scaffold_secret_key_base_replace_in_prod_32bytes!!"

config :phoenix, :json_library, Jason

config :logger, :console, format: "[$level] $message\n"

import_config "#{config_env()}.exs"
