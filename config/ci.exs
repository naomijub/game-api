use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :game_api, GameApiWeb.Endpoint,
  http: [port: 4000],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :game_api, GameApi.Repo,
  adapter: Mongo.Ecto,
  hostname: "mongo",
  database: "sample",
  port: 27017,
  pool_size: 5

# Configure MOCKs
config :game_api, :game, GameApi.GameMock
