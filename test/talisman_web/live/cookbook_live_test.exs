defmodule TalismanWeb.CookbookLiveTest do
  use TalismanWeb.ConnCase, async: true

  alias Talisman.Cookbooks
  alias Talisman.Cookbooks.ReadModels.Cookbook
  import Phoenix.LiveViewTest
  @endpoint TalismanWeb.Endpoint

  setup %{conn: conn} do
    %{user: user, conn: conn} = register_and_log_in_user(%{conn: conn})

    %{user: user, conn: conn}
  end

  describe "CookbookLive view" do
    test "displays a recipe", %{conn: conn, user: user} do
      new_cookbook = %{author_uuid: user.id, name: Faker.Pokemon.name(), recipes: []}

      assert :ok = Cookbooks.create_cookbook(new_cookbook)

      [%Cookbook{uuid: cookbook_uuid}] = Cookbooks.get_cookbooks_by_author_uuid(user.id)

      %{name: recipe_name} =
        new_recipe = %{
          cookbook_uuid: cookbook_uuid,
          author_uuid: user.id,
          name: Faker.Food.dish(),
          recipe: Faker.Lorem.paragraph(),
          ingredients: [Faker.Food.ingredient(), Faker.Food.ingredient()],
          category: Faker.Food.spice()
        }

      assert :ok = Cookbooks.add_recipe(new_recipe)

      {:ok, _view, html} = live(conn, "/cookbook/#{cookbook_uuid}")
      assert html =~ recipe_name
    end
  end
end
