defmodule Talisman.Cookbooks.Events.RecipeLiked do
  @moduledoc """
  RecipeLiked event
  """

  @required_fields :all

  use Talisman.Event

  defevent do
    field :like_author, :string
    field :recipe_uuid, Ecto.UUID
    field :cookbook_uuid, Ecto.UUID
  end
end
