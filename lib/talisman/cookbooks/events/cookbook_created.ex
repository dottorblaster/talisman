defmodule Talisman.Cookbooks.Events.CookbookCreated do
  @moduledoc """
  RecipeAdded event
  """

  @required_fields :all

  use Talisman.Event

  defevent do
    field :author_uuid, Ecto.UUID
    field :cookbook_uuid, Ecto.UUID
    field :name, :string
  end
end
