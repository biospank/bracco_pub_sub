defmodule BraccoPubSub.Repo do
  use Ecto.Repo,
    otp_app: :bracco_pub_sub,
    adapter: Ecto.Adapters.Postgres

  # def listen(event_name) do
  #   with {:ok, pid} <- Postgrex.Notifications.start_link(__MODULE__.config()),
  #        {:ok, ref} <- Postgrex.Notifications.listen(pid, event_name) do

  #     {:ok, pid, ref}
  #   end
  # end

  # def unlisten(pid, ref) do
  #   Postgrex.Notifications.unlisten(pid, ref)
  #   Process.exit(pid, :kill)
  # end
end
