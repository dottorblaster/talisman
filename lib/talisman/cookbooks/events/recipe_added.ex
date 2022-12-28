defmodule Talisman.Cookbooks.Events.RecipeAdded do
  @moduledoc """
  RecipeAdded event
  """

  @required_fields :all

  use Talisman.Event

  defevent do
    field :author_uuid, Ecto.UUID
    field :recipe, :string
    field :ingredients, {:array, :string}
    field :category, :string
  end
end
