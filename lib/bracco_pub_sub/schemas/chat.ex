defmodule BraccoPubSub.Schemas.Chat do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true} # Ecto generate uuid, not database

  schema "chats" do
    field(:name, :string)
    field(:actor_ids, {:array, :integer})
    field(:created_by, :integer)
    field(:created_at, :naive_datetime)
  end
end
