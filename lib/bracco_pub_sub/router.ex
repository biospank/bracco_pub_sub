defmodule BraccoPubSub.Router do
  import Plug.Conn
  use Plug.Router

  require Logger

  alias BraccoPubSub.{Listener, Schemas.Ticket, Repo}

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_file(200, "priv/static/index.html")
  end

  get "/bracco/:listener_id/events" do
    conn = set_response_headers(conn)
    conn = send_chunked(conn, 200)

    # Logger.info("Listening events for account: #{listener_id}")

    with {:ok, refs} <- Listener.subscribe(~w(tickets_changed comments_changed)) do
      loop(conn, String.to_integer(listener_id))
      Listener.unsubscribe(refs)
    else
      error ->
        send_error(conn, error)
    end

    conn
  end

  defp loop(conn, listener_id) do
    receive do
      {:notification, _pid, _ref, "comments_changed", payload} ->
        with {:ok, comment} <- get_payload_record(payload),
             {:ok, ticket} <- get_ticket(comment),
             {:ok, :match} <- check_listener(ticket, listener_id) do

          send_message(conn, payload)
        else
          error ->
            Logger.error("error: #{inspect error}")
        end

        loop(conn, listener_id)
      {:notification, _pid, _ref, "tickets_changed", payload} ->
        with {:ok, record} <- get_payload_record(payload),
             {:ok, :match} <- check_listener(record, listener_id) do

          send_message(conn, payload)
        else
          error ->
            Logger.error("error: #{inspect error}")
        end

        loop(conn, listener_id)
    after :timer.seconds(400) ->
      send_message(conn, "No available messages")
    end
  end

  defp get_ticket(%{ticket_id: ticket_id}) do
    case Repo.get(Ticket, ticket_id) do
      nil -> {:error, :not_found}
      ticket -> {:ok, ticket}
    end
  end

  defp get_payload_record(payload) do
    payload
    |> Jason.decode!(keys: :atoms)
    |> Map.fetch(:record)
  end

  defp check_listener(record, listener_id) do
    case record do
      %{reporter_id: ^listener_id} -> {:ok, :match}
      %{assignee_id: ^listener_id} -> {:ok, :match}
      _ -> {:error, :no_match}
    end
  end

  defp set_response_headers(conn) do
    conn
    |> put_resp_header("Content-Type", "text/event-stream")
    |> put_resp_header("Cache-Control", "no-cache")
    |> put_resp_header("Connection", "keep-alive")
    |> put_resp_header("Access-Control-Allow-Origin", "*")
  end

  defp send_message(conn, message) do
    chunk(conn, "event: \"message\"\n\ndata: {\"message\": #{message}}\n\n")
  end

  defp send_error(conn, error) do
    chunk(conn, "event: \"error\"\n\ndata: {\"error\": #{inspect error}}\n\n")
  end
end
