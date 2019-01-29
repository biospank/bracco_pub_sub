defmodule BraccoPubSub.Repo.Migrations.CreateAddressbook do
  use Ecto.Migration

  def change do
    create table(:addressbook) do
      add(:company, :string, null: false)
      add(:firstname, :string, null: false)
      add(:lastname, :string, null: false)
      add(:email, :string)
      add(:mobilephone, :string)
      add(:homephone, :string)
      add(:officephone, :string)
      add(:fax, :string)
      add(:archived, :boolean, default: false)
    end
  end
end
