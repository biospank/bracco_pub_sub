defmodule BraccoPubSub.Repo do
  use Ecto.Repo,
    otp_app: :bracco_pub_sub,
    adapter: Ecto.Adapters.Postgres
end
