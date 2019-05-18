defmodule BraccoPubSub.Utils do
  def get_payload_record(payload) do
    payload
    |> Jason.decode!(keys: :atoms)
    |> Map.fetch(:record)
  end
end
