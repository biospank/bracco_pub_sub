defmodule BraccoPubSub.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: true) do
      add :chat_uuid, references(:chats, type: :uuid, column: :uuid), null: false
      add :text, :string, null: false
      add(:created_by, references(:accounts))
      add(:created_at, :timestamp, default: fragment("now()"))
    end

    create index(:messages, [:chat_uuid])
    create index(:messages, [:created_at])
  end
end
