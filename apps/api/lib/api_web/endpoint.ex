defmodule ApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :api

  socket "/socket", ApiWeb.UserSocket, websocket: [connect_info: [:peer_data, :x_headers]]

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.Parsers, parsers: [:json], pass: ["*/*"], json_decoder: Phoenix.json_library()
  plug Plug.MethodOverride
  plug Plug.Head

  plug ApiWeb.Router
end
