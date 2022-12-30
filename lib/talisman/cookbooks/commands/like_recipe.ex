defmodule Talisman.Cookbooks.Commands.LikeRecipe do
  @moduledoc """
  LikeRecipe command
  """

  @required_fields :all

  use Talisman.Command

  defcommand do
    field :like_author, :string
    field :recipe_uuid, Ecto.UUID
    field :cookbook_uuid, Ecto.UUID
  end
end
