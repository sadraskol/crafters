use Mix.Config

config :crafters, CraftersWeb.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT"}, compress: true],
  url: [host: "someurl.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  root: ".",
  version: Application.spec(:phoenix_distillery, :vsn),
  code_reloader: false

config :crafters, Crafters.Repo,
  adapter: Ecto.Adapters.Postgres,
  size: 20

# Do not print debug messages in production
config :logger, level: :info

config :phoenix, :serve_endpoints, true

# Configure your database
config :crafters, Crafters.Repo, adapter: Sqlite.Ecto2, database: "/var/cafters/crafters.db"
