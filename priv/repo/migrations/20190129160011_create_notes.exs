defmodule BraccoPubSub.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add(:title, :string)
      add(:description, :text)
      add(:archived, :boolean, default: false)
      add(:alarm_date, :date)
      add(:alarm_time, :time)
      add(:account_id, references(:accounts))
      add(:created_at, :timestamp, default: fragment("now()"))
    end

    create index(:notes, [:account_id])
  end
end
