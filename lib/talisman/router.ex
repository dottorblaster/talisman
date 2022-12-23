defmodule Talisman.Router do
  @moduledoc """
  Commands router
  """

  use Commanded.Commands.Router

  alias Talisman.Accounts.Aggregates.User
  alias Talisman.Accounts.Commands.RegisterUser

  dispatch([RegisterUser], to: User, identity: :user_uuid)
end
