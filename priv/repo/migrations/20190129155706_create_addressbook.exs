defmodule BraccoPubSub.Repo.Migrations.CreateAddressbook do
  use Ecto.Migration

  def change do
    create table(:addressbook) do
      add(:company, :string)
      add(:firstname, :string)
      add(:lastname, :string)
      add(:email, :string)
      add(:vat_number, :string, limit: 11)
      add(:mobilephone, :string)
      add(:homephone, :string)
      add(:officephone, :string)
      add(:fax, :string)
      add(:archived, :boolean, default: false)
      add(:business_category, :string)
      add(:address, :string)
      add(:notes, :text)
    end

    create index(:addressbook, [:company])
    create index(:addressbook, [:firstname])
    create index(:addressbook, [:lastname])
    create index(:addressbook, [:email])
    create index(:addressbook, [:mobilephone])
  end
end
