defmodule Talisman.Accounts.Aggregates.User do
  @moduledoc """
  User aggregate
  """

  alias Talisman.Accounts.Aggregates.User
  alias Talisman.Accounts.Commands.RegisterUser
  alias Talisman.Accounts.Events.UserRegistered

  @required_fields [:uuid, :username, :hashed_password, :email]

  use Talisman.Type

  deftype do
    field :uuid, Ecto.UUID
    field :username, :string
    field :bio, :string
    field :hashed_password, :string
    field :email, :string
  end

  @doc """
  Register a new user
  """
  def execute(%User{uuid: nil}, %RegisterUser{
        user_uuid: user_uuid,
        username: username,
        email: email,
        hashed_password: hashed_password
      }),
      do:
        UserRegistered.new!(%{
          user_uuid: user_uuid,
          username: username,
          email: email,
          hashed_password: hashed_password
        })

  @doc """
  Modify the state after a user registration
  """
  def apply(%User{uuid: nil} = user, %UserRegistered{
        user_uuid: user_uuid,
        username: username,
        email: email,
        hashed_password: hashed_password
      }),
      do: %User{
        user
        | uuid: user_uuid,
          username: username,
          email: email,
          hashed_password: hashed_password
      }
end
