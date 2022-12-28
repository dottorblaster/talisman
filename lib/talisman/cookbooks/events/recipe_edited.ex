defmodule Talisman.Cookbooks.Events.RecipeEdited do
  @moduledoc """
  RecipeEdited event
  """

  @required_fields :all

  use Talisman.Event

  defevent do
    field :recipe, :string
    field :ingredients, {:array, :string}
    field :category, :string
  end
end
