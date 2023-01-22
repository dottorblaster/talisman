defmodule Talisman.Cookbooks do
  @moduledoc """
  The Cookbook context.
  """

  import Ecto.Query, warn: false
  alias Talisman.Commanded

  alias Talisman.Cookbooks.Commands.{AddRecipe, CreateCookbook, LikeRecipe}
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
    attrs
    |> Map.put(:recipe_uuid, UUID.uuid4())
    |> AddRecipe.new!()
    |> Commanded.dispatch(consistency: :strong)
  end

  def get_cookbooks_by_author_uuid(uuid), do: uuid |> Cookbook.by_author_uuid() |> Repo.all()

  def get_cookbook(uuid), do: uuid |> Cookbook.by_cookbook_uuid() |> Repo.one()

  def like_recipe(attrs \\ %{}),
    do: attrs |> LikeRecipe.new!() |> Commanded.dispatch(consistency: :strong)
end
