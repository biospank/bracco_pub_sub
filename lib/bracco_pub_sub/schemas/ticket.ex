defmodule BraccoPubSub.Schemas.Ticket do
  use Ecto.Schema

  schema "tickets" do
    field(:title, :string)
    field(:description, :string)
  end
end
