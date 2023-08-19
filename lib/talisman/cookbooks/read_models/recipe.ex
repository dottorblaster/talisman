defmodule Talisman.Cookbooks.ReadModels.Recipe do
  @moduledoc """
  Recipe read model.
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Talisman.Cookbooks.ReadModels.Recipe

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "recipes" do
    field :cookbook_uuid, :binary_id
    field :author_uuid, :binary_id
    field :recipe, :string
    field :like_count, :integer
    field :liked_by, {:array, :string}
    field :ingredients, {:array, :string}
    field :published_at, :naive_datetime
    field :slug, :string
    field :name, :string
    field :category, :string

    timestamps()
  end

  def changeset(recipe, attrs) do
    cast(recipe, attrs, __MODULE__.__schema__(:fields))
  end

  def by_cookbook_uuid(cookbook_uuid) do
    from u in Recipe,
      where: u.cookbook_uuid == ^cookbook_uuid
  end
end
