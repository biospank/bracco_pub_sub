defmodule BraccoPubSub.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:firstname, :string)
      add(:lastname, :string)
      add(:email, :string)
      add(:psw, :string)
      add(:confirm_psw, :string)
      add(:profile, :integer)
      add(:nickname, :string)
      add(:mobilephone, :string)
      add(:status, :integer, default: 1)
      add(:avatar_color, :string, default: "pink")
      add(:online, :boolean, default: false)
      add(:deleted, :boolean, default: false)
    end
  end
end
