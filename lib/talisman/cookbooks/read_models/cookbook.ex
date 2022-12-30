defmodule Talisman.Cookbooks.ReadModels.Cookbook do
  @moduledoc """
  Cookbook read model.
  """
  use Ecto.Schema

  import Ecto.Query

  alias Talisman.Cookbooks.ReadModels.Cookbook

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "cookbooks" do
    field :author_uuid, :binary_id
    field :name, :string
    field :recipes, {:array, :map}

    timestamps()
  end

  def by_author_uuid(author_uuid) do
    from u in Cookbook,
      where: u.author_uuid == ^author_uuid
  end
end
