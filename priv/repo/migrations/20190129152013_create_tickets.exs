defmodule BraccoPubSub.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
   create table(:tickets) do
    add(:title, :string, null: false)
    add(:description, :text)
    add(:status, :integer, default: 0)
    add(:archived, :boolean, default: false)
    add(:expire_at, :date)
    add(:assignees_id, {:array, :integer}, default: [])
    add(:created_at, :timestamp, default: fragment("now()"))
    add(:created_by, references(:accounts))
    add(:updated_at, :timestamp, default: fragment("now()"))
    add(:updated_by, references(:accounts))
   end
  end
end
