defmodule Talisman.Cookbooks.Commands.EditRecipe do
  @moduledoc """
  EditRecipe command 
  """

  @required_fields :all

  use Talisman.Command

  defcommand do
    field :cookbook_uuid, Ecto.UUID
    field :recipe_uuid, Ecto.UUID
    field :name, :string
    field :recipe, :string
    field :ingredients, {:array, :string}
    field :category, :string
  end
end
