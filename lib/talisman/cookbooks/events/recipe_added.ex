defmodule Talisman.Cookbooks.Events.RecipeAdded do
  @moduledoc """
  RecipeAdded event
  """

  @required_fields [:author_uuid, :recipe_uuid, :cookbook_uuid, :name, :recipe, :ingredients]

  use Talisman.Event

  defevent do
    field :author_uuid, Ecto.UUID
    field :recipe_uuid, Ecto.UUID
    field :cookbook_uuid, Ecto.UUID
    field :name, :string
    field :recipe, :string
    field :ingredients, {:array, :string}
    field :category, :string
  end
end
