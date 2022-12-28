defmodule Talisman.Cookbooks.Events.RecipeDeleted do
  @moduledoc """
  RecipeDeleted event
  """

  @required_fields :all

  use Talisman.Event

  defevent do
    field :recipe_uuid, Ecto.UUID
  end
end
