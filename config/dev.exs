use Mix.Config

config :bracco_pub_sub, BraccoPubSub.Repo,
  database: "bracco",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 5
