defmodule Talisman.Accounts.Events.UserRegistered do
  @moduledoc """
  UserRegistered event
  """

  @required_fields :all

  use Talisman.Event

  defevent do
    field :user_uuid, Ecto.UUID
    field :username, :string
    field :email, :string
    field :hashed_password, :string
  end
end
