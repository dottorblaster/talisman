defmodule TalismanWeb.RecipeLiveTest do
  use TalismanWeb.ConnCase, async: true

  alias Talisman.Cookbooks
  alias Talisman.Cookbooks.ReadModels.{Cookbook, Recipe}
  import Phoenix.LiveViewTest
  @endpoint TalismanWeb.Endpoint

  setup %{conn: conn} do
    %{user: user, conn: conn} = register_and_log_in_user(%{conn: conn})

    %{user: user, conn: conn}
  end

  describe "RecipeLive view" do
    test "displays a recipe", %{conn: conn} do
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
                   uuid: recipe_uuid,
                   name: ^recipe_name,
                   recipe: ^recipe_body,
                   ingredients: ^recipe_ingredients
                 }
               ]
             } = Cookbooks.get_cookbook(cookbook_uuid)

      {:ok, _view, html} = live(conn, "/recipe/#{recipe_uuid}")
      assert html =~ recipe_body
    end
  end
end
