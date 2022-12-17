defmodule Talisman.Accounts.User do
  @moduledoc """
  User context
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts_users" do
    field :bio, :string
    field :email, :string
    field :hashed_password, :string
    field :image, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hashed_password, :bio, :image])
    |> validate_required([:username, :email, :hashed_password, :bio, :image])
  end
end
