use Mix.Config

config :bracco_pub_sub, BraccoPubSub.Repo,
  database: "bracco",
  username: "bracco",
  password: "iladiro",
  hostname: "localhost",
  pool_size: 10


  # Release successfully built!
  # To start the release you have built, you can use one of the following tasks:

  #     # start a shell, like 'iex -S mix'
  #     > _build/prod/rel/bracco_pub_sub/bin/bracco_pub_sub console

  #     # start in the foreground, like 'mix run --no-halt'
  #     > _build/prod/rel/bracco_pub_sub/bin/bracco_pub_sub foreground

  #     # start in the background, must be stopped with the 'stop' command
  #     > _build/prod/rel/bracco_pub_sub/bin/bracco_pub_sub start

  # If you started a release elsewhere, and wish to connect to it:

  #     # connects a local shell to the running node
  #     > _build/prod/rel/bracco_pub_sub/bin/bracco_pub_sub remote_console

  #     # connects directly to the running node's console
  #     > _build/prod/rel/bracco_pub_sub/bin/bracco_pub_sub attach

  # For a complete listing of commands and their use:

  #     > _build/prod/rel/bracco_pub_sub/bin/bracco_pub_sub help
