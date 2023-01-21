defmodule Talisman.Cookbooks do
  @moduledoc """
  The Cookbook context.
  """

  import Ecto.Query, warn: false
  alias Talisman.Commanded

  alias Talisman.Cookbooks.Commands.CreateCookbook
  alias Talisman.Cookbooks.ReadModels.Recipe

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
end
