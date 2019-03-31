defmodule BraccoPubSub.Repo.Migrations.AddNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add(:recipient_id, :integer)
      add(:operation, :string)
      add(:table, :string)
      add(:record, :map, default: %{})

      timestamps()
    end

    create index(:notifications, [:recipient_id])
  end
end
