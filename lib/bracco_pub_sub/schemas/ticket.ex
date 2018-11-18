defmodule BraccoPubSub.Schemas.Ticket do
  use Ecto.Schema

  schema "tickets" do
    field(:title, :string)
    field(:description, :string)
    field(:reporter_id, :integer)
    field(:assignee_id, :integer)
    field(:archived, :boolean)
    field(:status, :integer)
    field(:expire_date, :date)
    field(:creation_date, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end
end
