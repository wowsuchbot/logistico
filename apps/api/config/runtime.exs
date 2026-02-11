import Config

if config_env() == :prod do
  config :api, ApiWeb.Endpoint, url: [host: System.get_env("PHX_HOST", "localhost"), port: 443, scheme: "https"]
  config :api, :tenant_domain_suffix, System.get_env("TENANT_DOMAIN_SUFFIX", ".vsaas.io")
  config :api, :rpc_url, System.get_env("RPC_URL")
  config :api, :factory_address, System.get_env("FACTORY_ADDRESS")
end
