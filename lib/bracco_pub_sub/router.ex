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
        # Logger.info("comments changed payload: #{inspect payload}")
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
        # Logger.info("tickets changed payload: #{inspect payload}")
        with {:ok, record} <- get_payload_record(payload),
             {:ok, :match} <- check_listener(record, listener_id) do

          send_message(conn, payload)
        else
          error ->
            Logger.error("error: #{inspect error}")
        end

        loop(conn, listener_id)
      {:notification, _pid, _ref, "documents_changed", payload} ->
        # Logger.info("documents changed payload: #{inspect payload}")
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
    Logger.info("listener_id: #{inspect listener_id}")
    Logger.info("record: #{inspect record}")
    case record do
      %{created_by: ^listener_id, updated_by: updater} -> # for ticket and comments
        if updater != listener_id do
          {:ok, :match}
        else
          {:error, :no_match}
        end
      %{share_with: assignees, updated_by: updater} -> # for comments
        if listener_id in (assignees -- [updater]) do
          {:ok, :match}
        else
          {:error, :no_match}
        end
      %{assignees_id: assignees, updated_by: updater} -> # for tickets
        if listener_id in (assignees -- [updater]) do
          {:ok, :match}
        else
          {:error, :no_match}
        end
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
