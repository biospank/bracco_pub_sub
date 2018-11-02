defmodule BraccoPubSub.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:tickets) do
      add(:title, :string, null: true)
      add(:description, :string, null: true)
    end
  end
end
