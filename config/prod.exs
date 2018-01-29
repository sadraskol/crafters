use Mix.Config

config :crafters, CraftersWeb.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost", port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  root: ".",
  version: Application.spec(:phoenix_distillery, :vsn),
  code_reloader: false

# Do not print debug messages in production
config :logger, level: :info

config :phoenix, :serve_endpoints, true

import_config "prod.secret.exs"
