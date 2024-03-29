defmodule Talisman.Cookbooks.Commands.AddRecipe do
  @moduledoc """
  AddRecipe command
  """

  @required_fields [:cookbook_uuid, :recipe_uuid, :name, :recipe, :ingredients]

  use Talisman.Command

  defcommand do
    field :cookbook_uuid, Ecto.UUID
    field :recipe_uuid, Ecto.UUID
    field :author_uuid, Ecto.UUID
    field :recipe, :string
    field :name, :string
    field :ingredients, {:array, :string}
    field :category, :string
  end
end
