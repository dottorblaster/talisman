defmodule Talisman.Cookbooks.Projectors.Cookbook do
  @moduledoc """
  User projector
  """

  use Commanded.Projections.Ecto,
    name: "Cookbooks.Projectors.Cookbook",
    application: Talisman.Commanded,
    repo: Talisman.Repo,
    consistency: :strong

  alias Talisman.Cookbooks.Events.{
    CookbookCreated,
    RecipeAdded,
    RecipeDeleted,
    RecipeEdited,
    RecipeLiked
  }

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
        slug: Slug.slugify(name),
        like_count: 0
      })
    end
  )

  project(
    %RecipeLiked{
      like_author: like_author,
      recipe_uuid: recipe_uuid
    },
    fn multi ->
      Ecto.Multi.insert(multi, :recipe, %Recipe{uuid: recipe_uuid},
        conflict_target: :uuid,
        on_conflict: [
          inc: [like_count: 1],
          push: [liked_by: like_author]
        ]
      )
    end
  )

  project(
    %RecipeEdited{
      recipe_uuid: recipe_uuid,
      name: new_name,
      recipe: new_recipe,
      ingredients: new_ingredients,
      category: new_category
    },
    fn multi ->
      changeset =
        Recipe
        |> Talisman.Repo.get!(recipe_uuid)
        |> Recipe.changeset(%{
          name: new_name,
          recipe: new_recipe,
          ingredients: new_ingredients,
          category: new_category
        })

      Ecto.Multi.update(multi, :recipe, changeset)
    end
  )

  project(%RecipeDeleted{recipe_uuid: recipe_uuid}, fn multi ->
    Ecto.Multi.delete(multi, :recipe, %Recipe{uuid: recipe_uuid})
  end)
end
