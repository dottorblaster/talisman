defmodule Talisman.Cookbooks.Aggregates.CookbookTest do
  use Talisman.AggregateCase, aggregate: Talisman.Cookbooks.Aggregates.Cookbook

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

  describe "create cookbook" do
    @tag :unit
    test "should succeed when valid" do
      %CreateCookbook{author_uuid: author_uuid, cookbook_uuid: cookbook_uuid, name: name} =
        create_cookbook_command = build(:create_cookbook_command)

      assert_events(create_cookbook_command, [
        %CookbookCreated{
          author_uuid: author_uuid,
          cookbook_uuid: cookbook_uuid,
          name: name
        }
      ])
    end
  end

  describe "add recipe" do
    test "should succeed" do
      %CreateCookbook{
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid
      } = create_cookbook_command = build(:create_cookbook_command)

      %AddRecipe{
        recipe_uuid: recipe_uuid,
        recipe: recipe,
        name: name,
        ingredients: ingredients,
        category: category
      } =
        add_recipe_command =
        build(:add_recipe_command, author_uuid: author_uuid, cookbook_uuid: cookbook_uuid)

      assert_events([create_cookbook_command, add_recipe_command], [
        %RecipeAdded{
          recipe_uuid: recipe_uuid,
          author_uuid: author_uuid,
          cookbook_uuid: cookbook_uuid,
          name: name,
          recipe: recipe,
          ingredients: ingredients,
          category: category
        }
      ])
    end
  end

  describe "edit recipe" do
    test "should succeed" do
      %CreateCookbook{
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid
      } = create_cookbook_command = build(:create_cookbook_command)

      %AddRecipe{
        recipe_uuid: recipe_uuid
      } =
        add_recipe_command =
        build(:add_recipe_command, author_uuid: author_uuid, cookbook_uuid: cookbook_uuid)

      %EditRecipe{
        recipe: new_recipe,
        name: new_name,
        ingredients: new_ingredients,
        category: new_category
      } =
        edit_recipe_command =
        build(:edit_recipe_command, cookbook_uuid: cookbook_uuid, recipe_uuid: recipe_uuid)

      assert_events([create_cookbook_command, add_recipe_command, edit_recipe_command], [
        %RecipeEdited{
          recipe_uuid: recipe_uuid,
          cookbook_uuid: cookbook_uuid,
          name: new_name,
          recipe: new_recipe,
          ingredients: new_ingredients,
          category: new_category
        }
      ])
    end
  end

  describe "like recipe" do
    test "should succeed" do
      %CreateCookbook{
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid
      } = create_cookbook_command = build(:create_cookbook_command)

      %AddRecipe{
        recipe_uuid: recipe_uuid
      } =
        add_recipe_command =
        build(:add_recipe_command, author_uuid: author_uuid, cookbook_uuid: cookbook_uuid)

      %LikeRecipe{
        recipe_uuid: recipe_uuid,
        cookbook_uuid: cookbook_uuid,
        like_author: like_author
      } =
        like_recipe_command =
        build(:like_recipe_command, cookbook_uuid: cookbook_uuid, recipe_uuid: recipe_uuid)

      assert_events([create_cookbook_command, add_recipe_command, like_recipe_command], [
        %RecipeLiked{
          recipe_uuid: recipe_uuid,
          cookbook_uuid: cookbook_uuid,
          like_author: like_author
        }
      ])
    end
  end

  describe "delete recipe" do
    test "should succeed" do
      %CreateCookbook{
        author_uuid: author_uuid,
        cookbook_uuid: cookbook_uuid
      } = create_cookbook_command = build(:create_cookbook_command)

      %AddRecipe{
        recipe_uuid: recipe_uuid
      } =
        add_recipe_command =
        build(:add_recipe_command, author_uuid: author_uuid, cookbook_uuid: cookbook_uuid)

      %DeleteRecipe{
        recipe_uuid: recipe_uuid,
        cookbook_uuid: cookbook_uuid
      } =
        delete_recipe_command =
        build(:delete_recipe_command, cookbook_uuid: cookbook_uuid, recipe_uuid: recipe_uuid)

      assert_events([create_cookbook_command, add_recipe_command, delete_recipe_command], [
        %RecipeDeleted{
          recipe_uuid: recipe_uuid,
          cookbook_uuid: cookbook_uuid
        }
      ])
    end
  end
end
