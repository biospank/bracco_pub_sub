defmodule BraccoPubSub.Schemas.Document do
  use Ecto.Schema

  schema "documents" do
    field(:title, :string)
    field(:body_text, :string)
    field(:archived, :boolean)
    field(:share_with, {:array, :integer})
    field(:created_by, :integer)
    field(:created_at, :naive_datetime)
    field(:updated_by, :integer)
    field(:updated_at, :naive_datetime)
  end
end
