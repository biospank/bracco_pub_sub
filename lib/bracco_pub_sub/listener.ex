defmodule BraccoPubSub.Listener do
  use GenServer

  require Logger

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(args) do
    with {:ok, _pid, _ref} <- BraccoPubSub.Repo.listen("tickets_changed") do
      {:ok, args}
    else
      error -> {:stop, error}
    end
  end

  @impl true
  def handle_info({:notification, _pid, _ref, "tickets_changed", payload}, _state) do
    with {:ok, data} <- Jason.decode(payload) do
      data
      |> inspect()
      |> Logger.info()

      {:noreply, :event_handled}
    else
      error -> {:stop, error, []}
    end
  end
end
