defmodule BraccoPubSub.Schemas.Notification do
  use Ecto.Schema

  import Ecto.Changeset

  schema "notifications" do
    field(:recipient_id, :integer)
    field(:operation, :string)
    field(:table, :string)
    field(:record, :map, default: %{})

    timestamps()
  end

  @fields ~w(recipient_id operation table record)a

  def create_changeset(attrs) do
    %__MODULE__{} |> cast(attrs, @fields)
  end
end
