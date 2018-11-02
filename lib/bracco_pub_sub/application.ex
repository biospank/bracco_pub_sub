defmodule BraccoPubSub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      BraccoPubSub.Repo,
      BraccoPubSub.Listener
      # Starts a worker by calling: BraccoPubSub.Worker.start_link(arg)
      # {BraccoPubSub.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BraccoPubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
