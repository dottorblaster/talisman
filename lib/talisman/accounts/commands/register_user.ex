defmodule Talisman.Accounts.Commands.RegisterUser do
  @moduledoc """
  RegisterUser command
  """

  @required_fields :all

  use Talisman.Command

  defcommand do
    field :user_uuid, Ecto.UUID
    field :username, :string
    field :email, :string
    field :hashed_password, :string
  end
end
