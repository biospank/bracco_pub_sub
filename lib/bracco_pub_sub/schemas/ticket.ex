defmodule BraccoPubSub.Schemas.Ticket do
  use Ecto.Schema

  schema "tickets" do
    field(:title, :string)
    field(:description, :string)
    field(:assignees_id, {:array, :integer})
    field(:archived, :boolean)
    field(:status, :integer)
    field(:expire_at, :date)
    field(:created_by, :integer)
    field(:created_at, :naive_datetime)
    field(:updated_by, :integer)
    field(:updated_at, :naive_datetime)
  end
end
