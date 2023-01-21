defmodule Talisman.Cookbooks.ReadModels.Cookbook do
  @moduledoc """
  Cookbook read model.
  """
  use Ecto.Schema

  import Ecto.Query

  alias Talisman.Cookbooks.ReadModels.{Cookbook, Recipe}

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "cookbooks" do
    field :author_uuid, :binary_id
    field :name, :string
    has_many :recipes, Recipe

    timestamps()
  end

  def by_cookbook_uuid(uuid) do
    from u in Cookbook,
      where: u.uuid == ^uuid,
      preload: [:recipes]
  end

  def by_author_uuid(author_uuid) do
    from u in Cookbook,
      where: u.author_uuid == ^author_uuid,
      preload: [:recipes]
  end
end
