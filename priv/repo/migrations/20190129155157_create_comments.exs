defmodule BraccoPubSub.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:body_text, :text, null: false)
      add(:ticket_id, references(:tickets))
      add(:account_id, references(:accounts))
      add(:created_at, :timestamp, default: fragment("now()"))
      add(:updated_at, :timestamp)
    end

    create index(:comments, [:ticket_id])
    create index(:comments, [:account_id])
  end
end
