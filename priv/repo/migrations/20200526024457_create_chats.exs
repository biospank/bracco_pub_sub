defmodule BraccoPubSub.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add(:actor_ids, {:array, :integer})
      add(:created_by, references(:accounts))
      add(:created_at, :timestamp, default: fragment("now()"))
    end
  end
end
