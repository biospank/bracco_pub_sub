defmodule BraccoPubSub.Repo.Migrations.CreateProfileSettings do
  use Ecto.Migration

  def change do
    create table(:profile_settings) do
      add(:account_id, references(:accounts))
      add(:tickets_notifications, :boolean, default: false)
    end

    create index(:profile_settings, [:account_id])
  end
end
