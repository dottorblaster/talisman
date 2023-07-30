defmodule Talisman.CookbooksTest do
  use Talisman.DataCase

  alias Talisman.Cookbooks
  alias Talisman.Cookbooks.ReadModels.{Cookbook, Recipe}

  describe "Cookbooks context" do
    test "create a cookbook" do
      %{author_uuid: author_uuid, name: name} =
        new_cookbook = %{author_uuid: Faker.UUID.v4(), name: Faker.Pokemon.name(), recipes: []}

      assert :ok = Cookbooks.create_cookbook(new_cookbook)

      assert [%Cookbook{author_uuid: ^author_uuid, name: ^name}] =
               Cookbooks.get_cookbooks_by_author_uuid(author_uuid)
    end

    test "create a cookbook and append a recipe to it" do
      %{author_uuid: author_uuid} =
        new_cookbook = %{author_uuid: Faker.UUID.v4(), name: Faker.Pokemon.name(), recipes: []}

      assert :ok = Cookbooks.create_cookbook(new_cookbook)

      [%Cookbook{uuid: cookbook_uuid}] = Cookbooks.get_cookbooks_by_author_uuid(author_uuid)

      %{name: recipe_name, recipe: recipe_body, ingredients: recipe_ingredients} =
        new_recipe = %{
          cookbook_uuid: cookbook_uuid,
          author_uuid: author_uuid,
          name: Faker.Food.dish(),
          recipe: Faker.Lorem.paragraph(),
          ingredients: [Faker.Food.ingredient(), Faker.Food.ingredient()],
          category: Faker.Food.spice()
        }

      assert :ok = Cookbooks.add_recipe(new_recipe)

      assert %Cookbook{
               uuid: ^cookbook_uuid,
               recipes: [
                 %Recipe{
                   name: ^recipe_name,
                   recipe: ^recipe_body,
                   ingredients: ^recipe_ingredients
                 }
               ]
             } = Cookbooks.get_cookbook(cookbook_uuid)
    end

    test "create a cookbook and append a recipe to it, with an empty category" do
      %{author_uuid: author_uuid} =
        new_cookbook = %{author_uuid: Faker.UUID.v4(), name: Faker.Pokemon.name(), recipes: []}

      assert :ok = Cookbooks.create_cookbook(new_cookbook)

      [%Cookbook{uuid: cookbook_uuid}] = Cookbooks.get_cookbooks_by_author_uuid(author_uuid)

      %{name: recipe_name, recipe: recipe_body, ingredients: recipe_ingredients} =
        new_recipe = %{
          cookbook_uuid: cookbook_uuid,
          author_uuid: author_uuid,
          name: Faker.Food.dish(),
          recipe: Faker.Lorem.paragraph(),
          ingredients: [Faker.Food.ingredient(), Faker.Food.ingredient()]
        }

      assert :ok = Cookbooks.add_recipe(new_recipe)

      assert %Cookbook{
               uuid: ^cookbook_uuid,
               recipes: [
                 %Recipe{
                   name: ^recipe_name,
                   recipe: ^recipe_body,
                   ingredients: ^recipe_ingredients
                 }
               ]
             } = Cookbooks.get_cookbook(cookbook_uuid)
    end

    test "liking a recipe should work as expected" do
      %{author_uuid: author_uuid} =
        new_cookbook = %{author_uuid: Faker.UUID.v4(), name: Faker.Pokemon.name(), recipes: []}

      assert :ok = Cookbooks.create_cookbook(new_cookbook)

      [%Cookbook{uuid: cookbook_uuid}] = Cookbooks.get_cookbooks_by_author_uuid(author_uuid)

      new_recipe = %{
        cookbook_uuid: cookbook_uuid,
        author_uuid: author_uuid,
        name: Faker.Food.dish(),
        recipe: Faker.Lorem.paragraph(),
        ingredients: [Faker.Food.ingredient(), Faker.Food.ingredient()],
        category: Faker.Food.spice()
      }

      assert :ok = Cookbooks.add_recipe(new_recipe)

      %Cookbook{
        recipes: [
          %Recipe{
            uuid: recipe_uuid
          }
        ]
      } = Cookbooks.get_cookbook(cookbook_uuid)

      like_author_1 = Faker.Internet.email()
      like_author_2 = Faker.Internet.email()

      assert :ok =
               Cookbooks.like_recipe(%{
                 cookbook_uuid: cookbook_uuid,
                 recipe_uuid: recipe_uuid,
                 like_author: like_author_1
               })

      assert :ok =
               Cookbooks.like_recipe(%{
                 cookbook_uuid: cookbook_uuid,
                 recipe_uuid: recipe_uuid,
                 like_author: like_author_2
               })

      assert %Cookbook{
               recipes: [
                 %Recipe{
                   uuid: ^recipe_uuid,
                   like_count: 2,
                   liked_by: [^like_author_1, ^like_author_2]
                 }
               ]
             } = Cookbooks.get_cookbook(cookbook_uuid)
    end
  end
end
