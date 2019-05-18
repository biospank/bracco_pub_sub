defmodule BraccoPubSub.Schemas.Comment do
  use Ecto.Schema

  schema "comments" do
    field(:body_text, :string)
    field(:ticket_id, :integer)
    field(:account_id, :integer)
    field(:created_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end
end
