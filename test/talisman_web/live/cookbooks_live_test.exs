defmodule TalismanWeb.CookbooksLiveTest do
  use TalismanWeb.ConnCase, async: true

  alias Talisman.Cookbooks
  import Phoenix.LiveViewTest
  @endpoint TalismanWeb.Endpoint

  setup %{conn: conn} do
    %{user: user, conn: conn} = register_and_log_in_user(%{conn: conn})

    %{user: user, conn: conn}
  end

  describe "RecipeLive view" do
    test "displays a recipe", %{conn: conn, user: user} do
      %{name: cookbook_name} =
        new_cookbook = %{author_uuid: user.id, name: Faker.Pokemon.name(), recipes: []}

      assert :ok = Cookbooks.create_cookbook(new_cookbook)

      {:ok, _view, html} = live(conn, "/cookbooks")
      assert html =~ cookbook_name
    end
  end
end
