defmodule Talisman.Cookbooks.Recipe do
  @moduledoc """
  Recipe type to be used mainly to be embedded inside a cookbook
  """

  @required_fields [
    :author_uuid,
    :recipe_uuid,
    :recipe,
    :like_count,
    :liked_by,
    :ingredients,
    :published_at,
    :slug,
    :name
  ]

  use Talisman.Type

  deftype do
    field :author_uuid, :binary
    field :recipe_uuid, :binary
    field :recipe, :string
    field :like_count, :integer
    field :liked_by, {:array, :string}
    field :ingredients, {:array, :string}
    field :published_at, :naive_datetime
    field :slug, :string
    field :name, :string
    field :category, :string
  end
end
