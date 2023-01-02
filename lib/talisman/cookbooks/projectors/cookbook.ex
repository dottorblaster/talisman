defmodule Talisman.Cookbooks.Projectors.Cookbook do
  @moduledoc """
  User projector
  """

  use Commanded.Projections.Ecto,
    name: "Cookbooks.Projectors.Cookbook",
    application: Talisman.Commanded,
    repo: Talisman.Repo,
    consistency: :strong

  alias Talisman.Cookbooks.Events.{CookbookCreated, RecipeAdded}
  alias Talisman.Cookbooks.ReadModels.{Cookbook, Recipe}

  project(
    %CookbookCreated{
      cookbook_uuid: cookbook_uuid,
      author_uuid: author_uuid,
      name: name
    },
    fn multi ->
      Ecto.Multi.insert(multi, :cookbook, %Cookbook{
        uuid: cookbook_uuid,
        author_uuid: author_uuid,
        name: name,
        recipes: []
      })
    end
  )

  project(
    %RecipeAdded{
      recipe_uuid: uuid,
      author_uuid: author_uuid,
      cookbook_uuid: cookbook_uuid,
      name: name,
      recipe: recipe,
      ingredients: ingredients,
      category: category
    },
    fn multi ->
      Ecto.Multi.insert(multi, :recipe, %Recipe{
        uuid: uuid,
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid,
        name: name,
        recipe: recipe,
        ingredients: ingredients,
        category: category,
        slug: Slug.slugify(name)
      })
    end
  )
end
