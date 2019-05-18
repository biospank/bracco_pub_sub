defmodule BraccoPubSub.Router do
  import Plug.Conn
  use Plug.Router

  require Logger

  alias BraccoPubSub.{
    Listener,
    Hub,
    Utils,
    Schemas.Ticket,
    Repo
  }

  # plug Plug.Static, at: "/", from: :bracco_pub_sub
  plug :match
  plug :dispatch

  @events_type ~w(
    tickets_changed
    comments_changed
    documents_changed
  )

  # get "/" do
  #   conn
  #   |> put_resp_header("content-type", "text/html; charset=utf-8")
  #   |> send_file(:ok, root())
  # end

  get "/" do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_file(200, "priv/static/index.html")
  end

  get "/bracco/:listener_id/events" do
    # IO.puts("Listening events for account: #{listener_id}")
    conn = set_response_headers(conn)
    conn = send_chunked(conn, 200)

    send_retry(conn)

    # Logger.info("Listening events for account: #{listener_id}")

    with {:ok, refs} <- Listener.subscribe(@events_type) do
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
      {:notification, _pid, _ref, "tickets_changed" = event, payload} ->
        # Logger.info("tickets changed payload: #{inspect payload}")
        with {:ok, record} <- Utils.get_payload_record(payload),
             {:ok, :match} <- Hub.match(event, listener_id, record) do

          send_message(conn, payload)
        else
          error ->
            Logger.error("error: #{inspect error}")
        end

        loop(conn, listener_id)
      {:notification, _pid, _ref, "comments_changed" = event, payload} ->
        # Logger.info("comments changed payload: #{inspect payload}")
        with {:ok, comment} <- Utils.get_payload_record(payload),
             {:ok, ticket} <- get_ticket(comment),
             {:ok, :match} <- Hub.match(event, listener_id, ticket, comment) do

          send_message(conn, payload)
        else
          error ->
            Logger.error("error: #{inspect error}")
        end
      {:notification, _pid, _ref, "documents_changed" = event, payload} ->
        # Logger.info("documents changed payload: #{inspect payload}")
        with {:ok, record} <- Utils.get_payload_record(payload),
              {:ok, :match} <- Hub.match(event, listener_id, record) do

          send_message(conn, payload)
        else
          error ->
            Logger.error("error: #{inspect error}")
        end

        loop(conn, listener_id)
    after :timer.seconds(60) ->
      loop(conn, listener_id)
      # send_message(conn, "No available messages")
    end
  end

  defp get_ticket(%{ticket_id: ticket_id}) do
    case Repo.get(Ticket, ticket_id) do
      nil -> {:error, :not_found}
      ticket -> {:ok, ticket}
    end
  end

  # defp store_notification(payload, listener_id) do
  #   payload
  #   |> Jason.decode!(keys: :atoms)
  #   |> Map.put(:recipient_id, listener_id)
  #   |> Notification.create_changeset()
  #   |> Repo.insert!()
  # end

  defp set_response_headers(conn) do
    conn
    |> put_resp_header("Content-Type", "text/event-stream")
    |> put_resp_header("Cache-Control", "no-cache")
    |> put_resp_header("Connection", "keep-alive")
    |> put_resp_header("Access-Control-Allow-Origin", "*")
  end

  defp send_message(conn, message) do
    chunk(conn, "event: \"message\"\n\nretry: 200\n\ndata: {\"message\": #{message}}\n\n")
  end

  defp send_retry(conn) do
    chunk(conn, "retry: 200\n\n")
  end

  defp send_error(conn, error) do
    chunk(conn, "event: \"error\"\n\ndata: {\"error\": #{inspect error}}\n\n")
  end

  # defp root do
  #   Enum.join([:code.priv_dir(:bracco_pub_sub), "/static/index.html"])
  # end
end
