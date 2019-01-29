defmodule BraccoPubSub.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:firstname, :string, null: false)
      add(:lastname, :string, null: false)
      add(:email, :string, null: false)
      add(:psw, :string, null: false)
      add(:confirm_psw, :string, null: false)
      add(:profile, :integer, null: false)
      add(:nickname, :string, null: false)
      add(:status, :integer, default: 1)
      add(:avatar_color, :string, default: "pink")
      add(:online, :boolean, default: false)
      add(:deleted, :boolean, default: false)
    end
  end
end
