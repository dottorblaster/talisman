defmodule Talisman.Cookbooks.Aggregates.CookbookTest do
  use Talisman.AggregateCase, aggregate: Talisman.Cookbooks.Aggregates.Cookbook

  alias Talisman.Cookbooks.Commands.{AddRecipe, CreateCookbook}
  alias Talisman.Cookbooks.Events.{CookbookCreated, RecipeAdded}

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
end
