defmodule BraccoPubSub.Router do
  import Plug.Conn
  use Plug.Router

  alias BraccoPubSub.Listener

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_file(200, "priv/static/index.html")
  end

  get "/bracco/events" do
    conn = set_response_headers(conn)
    conn = send_chunked(conn, 200)

    send_message(conn, "Waiting for messages...")

    # with {:ok, pid, ref} <- listen("tickets_changed") do
    with {:ok, ref} <- Listener.subscribe("tickets_changed") do
      loop(conn)
      Listener.unsubscribe(ref)
    else
      error ->
        send_error(conn, error)
    end

    conn
  end

  defp loop(conn) do
    receive do
      {:notification, _pid, _ref, "tickets_changed", payload} ->
        send_message(conn, payload)
        loop(conn)
      after :timer.seconds(60) ->
        send_message(conn, "No available messages")
    end
  end

  # defp listen(event_name) do
  #   BraccoPubSub.Repo.listen(event_name)
  # end

  # defp unlisten(pid, ref) do
  #   BraccoPubSub.Repo.unlisten(pid, ref)
  # end

  defp set_response_headers(conn) do
    conn
    |> put_resp_header("Content-Type", "text/event-stream")
    |> put_resp_header("Cache-Control", "no-cache")
    |> put_resp_header("Connection", "keep-alive")
    |> put_resp_header("Access-Control-Allow-Origin", "*")
  end

  defp send_message(conn, message) do
    chunk(conn, "event: \"message\"\n\ndata: {\"message\": \"#{message}\"}\n\n")
  end

  defp send_error(conn, error) do
    chunk(conn, "event: \"error\"\n\ndata: {\"error\": \"#{inspect error}\"}\n\n")
  end
end
