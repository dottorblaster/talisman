defmodule Talisman.Router do
  @moduledoc """
  Commands router
  """

  use Commanded.Commands.Router

  alias Talisman.Accounts.Aggregates.User
  alias Talisman.Accounts.Commands.RegisterUser

  alias Talisman.Cookbooks.Aggregates.Cookbook

  alias Talisman.Cookbooks.Commands.{
    AddRecipe,
    CreateCookbook,
    DeleteRecipe,
    EditRecipe,
    LikeRecipe
  }

  dispatch([RegisterUser], to: User, identity: :user_uuid)

  dispatch(
    [
      AddRecipe,
      CreateCookbook,
      DeleteRecipe,
      EditRecipe,
      LikeRecipe
    ],
    to: Cookbook,
    identity: :cookbook_uuid
  )
end
