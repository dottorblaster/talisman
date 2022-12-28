defmodule Talisman.Cookbook.Aggregates.Cookbook do
  @moduledoc """
  Cookbook aggregate
  """

  alias Talisman.Cookbooks.Aggregates.Cookbook

  alias Talisman.Cookbooks.Commands.{AddRecipe, CreateCookbook}

  alias Talisman.Cookbooks.Events.{CookbookCreated, RecipeAdded}

  alias Talisman.Cookbooks.Recipe

  @required_fields :all

  use Talisman.Type

  deftype do
    field :uuid, Ecto.UUID
    field :author_uuid, Ecto.UUID
    field :name, :string
    embeds_many :recipes, Cookbook.Recipe
  end

  @doc """
  Create a new cookbook
  """
  def execute(%Cookbook{uuid: nil}, %CreateCookbook{
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid,
        name: name
      }),
      do:
        CookbookCreated.new!(%{cookbook_uuid: cookbook_uuid, author_uuid: author_uuid, name: name})

  @doc """
  Add a recipe to a cookbook
  """
  def execute(%Cookbook{uuid: uuid}, %AddRecipe{
        cookbook_uuid: uuid,
        author_uuid: author_uuid,
        recipe: recipe,
        name: name,
        ingredients: ingredients,
        category: category
      }),
      do:
        RecipeAdded.new!(%{
          author_uuid: author_uuid,
          cookbook_uuid: uuid,
          name: name,
          recipe: recipe,
          ingredients: ingredients,
          category: category
        })

  @doc """
  Update the state with a new cookbook
  """
  def apply(%Cookbook{uuid: nil} = cookbook, %CookbookCreated{
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid,
        name: name
      }),
      do: %Cookbook{
        cookbook
        | uuid: cookbook_uuid,
          author_uuid: author_uuid,
          name: name,
          recipes: []
      }

  @doc """
  Update the state with a new recipe
  """
  def apply(%Cookbook{uuid: uuid, recipes: recipes} = cookbook, %RecipeAdded{
        cookbook_uuid: uuid,
        author_uuid: author_uuid,
        recipe: recipe,
        name: name,
        ingredients: ingredients,
        category: category
      }) do
    recipe =
      Recipe.new!(%{
        author_uuid: author_uuid,
        recipe: recipe,
        like_count: 0,
        ingredients: ingredients,
        slug: Slug.slugify(name),
        name: name
      })

    %Cookbook{cookbook | recipes: Enum.concat(recipes, recipe)}
  end
end
