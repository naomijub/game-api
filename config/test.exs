use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :game_api, GameApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn, truncate: 100

config :game_api, GameApi.Repo,
  adapter: Mongo.Ecto,
  # username: System.get_env("MONGO_USERNAME"),
  # password: System.get_env("MONGO_PASSWORD"),
  hostname: "db-test",
  database: "sample",
  port: 27017,
  pool_size: 10

# Configure MOCKs
config :game_api, :game, GameApi.GameMock
