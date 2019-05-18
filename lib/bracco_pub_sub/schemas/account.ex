defmodule BraccoPubSub.Schemas.Account do
  use Ecto.Schema

  schema "accounts" do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:email, :string)
    field(:psw, :string)
    field(:profile, :integer)
    field(:nickname, :string)
    field(:mobilephone, :string)
    field(:status, :integer, default: 1)
    field(:avatar_color, :string, default: "pink")
    field(:online, :boolean, default: false)
    field(:deleted, :boolean, default: false)
  end
end
