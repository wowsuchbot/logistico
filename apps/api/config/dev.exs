import Config

config :api, ApiWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  debug_errors: true,
  server: true

config :api, :tenant_domain_suffix, ".vsaas.io"
