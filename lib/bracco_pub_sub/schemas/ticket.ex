defmodule BraccoPubSub.Schemas.Ticket do
  use Ecto.Schema

  schema "tickets" do
    field(:title, :string)
    field(:description, :string)
    field(:created_by, :integer)
    field(:assignees_id, {:array, :integer})
    field(:archived, :boolean)
    field(:status, :integer)
    field(:expire_date, :date)
    field(:creation_date, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end
end
