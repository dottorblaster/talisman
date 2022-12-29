defmodule Talisman.Cookbooks.Aggregates.Cookbook do
  @moduledoc """
  Cookbook aggregate
  """

  alias Talisman.Cookbooks.Aggregates.Cookbook

  alias Talisman.Cookbooks.Commands.{
    AddRecipe,
    CreateCookbook,
    DeleteRecipe,
    EditRecipe,
    LikeRecipe
  }

  alias Talisman.Cookbooks.Events.{
    CookbookCreated,
    RecipeAdded,
    RecipeDeleted,
    RecipeEdited,
    RecipeLiked
  }

  alias Talisman.Cookbooks.Recipe

  @required_fields :all

  use Talisman.Type

  deftype do
    field :uuid, Ecto.UUID
    field :author_uuid, Ecto.UUID
    field :name, :string
    embeds_many :recipes, Cookbook.Recipe
  end

  def execute(%Cookbook{uuid: nil}, %CreateCookbook{
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid,
        name: name
      }),
      do:
        CookbookCreated.new!(%{cookbook_uuid: cookbook_uuid, author_uuid: author_uuid, name: name})

  def execute(%Cookbook{uuid: uuid}, %AddRecipe{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid,
        author_uuid: author_uuid,
        recipe: recipe,
        name: name,
        ingredients: ingredients,
        category: category
      }),
      do:
        RecipeAdded.new!(%{
          author_uuid: author_uuid,
          recipe_uuid: recipe_uuid,
          cookbook_uuid: uuid,
          name: name,
          recipe: recipe,
          ingredients: ingredients,
          category: category
        })

  def execute(%Cookbook{uuid: uuid}, %EditRecipe{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid,
        recipe: recipe,
        name: name,
        ingredients: ingredients,
        category: category
      }),
      do:
        RecipeEdited.new!(%{
          recipe_uuid: recipe_uuid,
          cookbook_uuid: uuid,
          name: name,
          recipe: recipe,
          ingredients: ingredients,
          category: category
        })

  def execute(%Cookbook{uuid: uuid}, %LikeRecipe{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid,
        like_author: like_author
      }),
      do:
        RecipeLiked.new!(%{
          recipe_uuid: recipe_uuid,
          cookbook_uuid: uuid,
          like_author: like_author
        })

  def execute(%Cookbook{uuid: uuid}, %DeleteRecipe{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid
      }),
      do:
        RecipeDeleted.new!(%{
          recipe_uuid: recipe_uuid,
          cookbook_uuid: uuid
        })

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

  def apply(%Cookbook{uuid: uuid, recipes: recipes} = cookbook, %RecipeAdded{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid,
        author_uuid: author_uuid,
        recipe: recipe,
        name: name,
        ingredients: ingredients,
        category: category
      }) do
    recipe =
      Recipe.new!(%{
        author_uuid: author_uuid,
        recipe_uuid: recipe_uuid,
        recipe: recipe,
        like_count: 0,
        liked_by: [],
        ingredients: ingredients,
        slug: Slug.slugify(name),
        name: name,
        category: category,
        published_at: DateTime.utc_now()
      })

    %Cookbook{cookbook | recipes: Enum.concat(recipes, [recipe])}
  end

  def apply(%Cookbook{uuid: uuid, recipes: recipes} = cookbook, %RecipeEdited{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid,
        recipe: recipe_content,
        name: name,
        ingredients: ingredients,
        category: category
      }) do
    %Cookbook{
      cookbook
      | recipes:
          Enum.map(recipes, fn %Recipe{recipe_uuid: target} = recipe ->
            if target == recipe_uuid do
              %Recipe{
                recipe
                | name: name,
                  recipe: recipe_content,
                  ingredients: ingredients,
                  category: category
              }
            else
              recipe
            end
          end)
    }
  end

  def apply(%Cookbook{uuid: uuid, recipes: recipes} = cookbook, %RecipeLiked{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid,
        like_author: like_author
      }) do
    %Cookbook{
      cookbook
      | recipes:
          Enum.map(recipes, fn %Recipe{
                                 recipe_uuid: operand,
                                 like_count: like_count,
                                 liked_by: liked_by
                               } = recipe ->
            if operand == recipe_uuid do
              %Recipe{
                recipe
                | like_count: like_count + 1,
                  liked_by: Enum.concat(liked_by, [like_author])
              }
            else
              recipe
            end
          end)
    }
  end

  def apply(%Cookbook{uuid: uuid, recipes: recipes} = cookbook, %RecipeDeleted{
        cookbook_uuid: uuid,
        recipe_uuid: recipe_uuid
      }) do
    %Cookbook{
      cookbook
      | recipes:
          Enum.reject(recipes, fn %Recipe{recipe_uuid: target} -> recipe_uuid == target end)
    }
  end
end
