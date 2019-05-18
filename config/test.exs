use Mix.Config

config :bracco_pub_sub, BraccoPubSub.Repo,
  database: "bracco_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 5
