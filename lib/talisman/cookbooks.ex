defmodule Talisman.Cookbooks do
  @moduledoc """
  The Cookbook context.
  """

  import Ecto.Query, warn: false
  alias Talisman.Commanded

  alias Talisman.Cookbooks.Commands.{
    AddRecipe,
    CreateCookbook,
    DeleteRecipe,
    EditRecipe,
    LikeRecipe
  }

  alias Talisman.Cookbooks.ReadModels.{Cookbook, Recipe}

  alias Talisman.Repo

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)

  def create_cookbook(attrs \\ %{}) do
    attrs
    |> Map.put(:cookbook_uuid, UUID.uuid4())
    |> CreateCookbook.new!()
    |> Commanded.dispatch(consistency: :strong)
  end

  def add_recipe(attrs \\ %{}) do
    with {:ok, command} <- attrs |> Map.put(:recipe_uuid, UUID.uuid4()) |> AddRecipe.new() do
      Commanded.dispatch(command, consistency: :strong)
    end
  end

  def get_cookbooks_by_author_uuid(uuid), do: uuid |> Cookbook.by_author_uuid() |> Repo.all()

  def get_cookbook(uuid), do: uuid |> Cookbook.by_cookbook_uuid() |> Repo.one()

  def like_recipe(attrs \\ %{}),
    do: attrs |> LikeRecipe.new!() |> Commanded.dispatch(consistency: :strong)

  def edit_recipe(user_uuid, attrs \\ %{}) do
    cookbook_uuid = Map.get(attrs, :cookbook_uuid)

    user_owns_cookbook =
      user_uuid
      |> get_cookbooks_by_author_uuid()
      |> Enum.any?(fn %{uuid: uuid, author_uuid: author_uuid} ->
        author_uuid == user_uuid and uuid == cookbook_uuid
      end)

    if user_owns_cookbook do
      with {:ok, command} <- attrs |> EditRecipe.new() do
        Commanded.dispatch(command, consistency: :strong)
      end
    else
      {:error, :cookbook_permission_denied}
    end
  end

  def delete_recipe(user_uuid, attrs \\ %{}) do
    cookbook_uuid = Map.get(attrs, :cookbook_uuid)

    user_owns_cookbook =
      user_uuid
      |> get_cookbooks_by_author_uuid()
      |> Enum.any?(fn %{uuid: uuid, author_uuid: author_uuid} ->
        author_uuid == user_uuid and uuid == cookbook_uuid
      end)

    if user_owns_cookbook do
      with {:ok, command} <- attrs |> DeleteRecipe.new() do
        Commanded.dispatch(command, consistency: :strong)
      end
    else
      {:error, :cookbook_permission_denied}
    end
  end
end
