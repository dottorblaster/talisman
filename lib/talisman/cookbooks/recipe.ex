defmodule Talisman.Cookbooks.Recipe do

@required_fields :all

use Talisman.Type

  deftype do
    field :author_bio, :string
    field :author_image, :string
    field :author_username, :string
    field :author_uuid, :binary
    field :body, :string
    field :description, :string
    field :favorite_count, :integer
    field :ingredients, {:array, :string}
    field :published_at, :naive_datetime
    field :slug, :string
    field :title, :string
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [
      :slug,
      :title,
      :description,
      :body,
      :ingredients,
      :favorite_count,
      :published_at,
      :author_uuid,
      :author_username,
      :author_bio,
      :author_image
    ])
    |> validate_required([
      :slug,
      :title,
      :description,
      :body,
      :ingredients,
      :favorite_count,
      :published_at,
      :author_uuid,
      :author_username,
      :author_bio,
      :author_image
    ])
  end
end
