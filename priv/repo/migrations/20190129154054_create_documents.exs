defmodule BraccoPubSub.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add(:title, :string, null: false)
      add(:body_text, :text)
      add(:archived, :boolean, default: false)
      add(:share_with, {:array, :integer}, default: [])
      add(:created_at, :timestamp, default: "now()")
      add(:created_by, references(:accounts))
      add(:updated_at, :timestamp, default: "now()")
      add(:updated_by, references(:accounts))
    end
  end
end
