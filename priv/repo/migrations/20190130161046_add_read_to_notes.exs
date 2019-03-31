defmodule BraccoPubSub.Repo.Migrations.AddReadToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add(:read, :boolean, default: false)
    end
  end
end
