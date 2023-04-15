defmodule Talisman.Router do
  @moduledoc """
  Commands router
  """

  use Commanded.Commands.Router

  alias Talisman.Cookbooks.Aggregates.Cookbook

  alias Talisman.Cookbooks.Commands.{
    AddRecipe,
    CreateCookbook,
    DeleteRecipe,
    EditRecipe,
    LikeRecipe
  }

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
