defmodule Talisman.CookbookTest do
  use Talisman.DataCase

  alias Talisman.Cookbook

  describe "recipes" do
    alias Talisman.Cookbook.Recipe

    import Talisman.CookbookFixtures

    @invalid_attrs %{author_bio: nil, author_image: nil, author_username: nil, author_uuid: nil, body: nil, description: nil, favorite_count: nil, ingredients: nil, published_at: nil, slug: nil, title: nil}

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Cookbook.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Cookbook.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      valid_attrs = %{author_bio: "some author_bio", author_image: "some author_image", author_username: "some author_username", author_uuid: "some author_uuid", body: "some body", description: "some description", favorite_count: 42, ingredients: [], published_at: ~N[2022-12-25 11:51:00], slug: "some slug", title: "some title"}

      assert {:ok, %Recipe{} = recipe} = Cookbook.create_recipe(valid_attrs)
      assert recipe.author_bio == "some author_bio"
      assert recipe.author_image == "some author_image"
      assert recipe.author_username == "some author_username"
      assert recipe.author_uuid == "some author_uuid"
      assert recipe.body == "some body"
      assert recipe.description == "some description"
      assert recipe.favorite_count == 42
      assert recipe.ingredients == []
      assert recipe.published_at == ~N[2022-12-25 11:51:00]
      assert recipe.slug == "some slug"
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cookbook.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      update_attrs = %{author_bio: "some updated author_bio", author_image: "some updated author_image", author_username: "some updated author_username", author_uuid: "some updated author_uuid", body: "some updated body", description: "some updated description", favorite_count: 43, ingredients: [], published_at: ~N[2022-12-26 11:51:00], slug: "some updated slug", title: "some updated title"}

      assert {:ok, %Recipe{} = recipe} = Cookbook.update_recipe(recipe, update_attrs)
      assert recipe.author_bio == "some updated author_bio"
      assert recipe.author_image == "some updated author_image"
      assert recipe.author_username == "some updated author_username"
      assert recipe.author_uuid == "some updated author_uuid"
      assert recipe.body == "some updated body"
      assert recipe.description == "some updated description"
      assert recipe.favorite_count == 43
      assert recipe.ingredients == []
      assert recipe.published_at == ~N[2022-12-26 11:51:00]
      assert recipe.slug == "some updated slug"
      assert recipe.title == "some updated title"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Cookbook.update_recipe(recipe, @invalid_attrs)
      assert recipe == Cookbook.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Cookbook.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Cookbook.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Cookbook.change_recipe(recipe)
    end
  end
end
