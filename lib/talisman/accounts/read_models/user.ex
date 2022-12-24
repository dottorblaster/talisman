defmodule Talisman.Accounts.ReadModels.User do
  @moduledoc """
  User read model.
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "accounts_users" do
    field :username, :string, primary_key: true
    field :email, :string, primary_key: true
    field :hashed_password, :string
    field :bio, :string
    field :image, :string

    timestamps()
  end
end
