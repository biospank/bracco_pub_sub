defmodule BraccoPubSub.Schemas.Message do
  use Ecto.Schema

  alias BraccoPubSub.Schemas.Chat

  @primary_key {:id, :binary_id, autogenerate: false} # database generate id

  schema "messages" do
    field(:text, :string)
    field(:created_by, :integer)
    field(:created_at, :naive_datetime)

    belongs_to(
      :chat,
      Chat,
      foreign_key: :chat_uuid,
      references: :uuid,
      type: :binary_id,
      primary_key: true
    )
  end
end
