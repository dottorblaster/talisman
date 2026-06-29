defmodule TalismanWeb.CookbooksLiveTest do
  use TalismanWeb.ConnCase, async: true

  alias Talisman.Cookbooks
  alias Talisman.Cookbooks.ReadModels.Cookbook
  import Phoenix.LiveViewTest
  @endpoint TalismanWeb.Endpoint

  setup %{conn: conn} do
    %{user: user, conn: conn} = register_and_log_in_user(%{conn: conn})

    %{user: user, conn: conn}
  end

  # Creates a cookbook owned by `user` and appends the given recipes.
  # Returns the persisted cookbook uuid.
  defp create_cookbook(user, name, recipes \\ []) do
    assert :ok = Cookbooks.create_cookbook(%{author_uuid: user.id, name: name, recipes: []})

    %Cookbook{uuid: uuid} =
      user.id
      |> Cookbooks.get_cookbooks_by_author_uuid()
      |> Enum.find(&(&1.name == name))

    Enum.each(recipes, fn recipe ->
      assert :ok =
               Cookbooks.add_recipe(
                 Map.merge(
                   %{
                     cookbook_uuid: uuid,
                     author_uuid: user.id,
                     recipe: "body",
                     ingredients: [],
                     category: nil
                   },
                   recipe
                 )
               )
    end)

    uuid
  end

  describe "header and totals" do
    test "shows cookbook and recipe totals", %{conn: conn, user: user} do
      create_cookbook(user, "Cozy soups", [
        %{name: "Minestrone", ingredients: ["beans"]},
        %{name: "Ribollita", ingredients: ["kale"]}
      ])

      create_cookbook(user, "Sunday baking", [%{name: "Focaccia", ingredients: ["flour"]}])

      {:ok, _view, html} = live(conn, "/cookbooks")

      assert html =~ "Your cookbooks"
      assert html =~ "2 cookbooks"
      assert html =~ "3 recipes in total"
    end

    test "links to the new cookbook page", %{conn: conn, user: user} do
      create_cookbook(user, "Cozy soups")

      {:ok, view, _html} = live(conn, "/cookbooks")

      assert has_element?(view, "a[href='/cookbooks/new']")
    end
  end

  describe "card content" do
    test "renders recipe count, category chips and pantry preview", %{conn: conn, user: user} do
      create_cookbook(user, "Curries & spice", [
        %{
          name: "Chana masala",
          ingredients: ["chickpeas", "onion", "tomato"],
          category: "Indian"
        },
        %{name: "Vindaloo", ingredients: ["pork", "garlic", "chickpeas"], category: "Spicy"}
      ])

      {:ok, _view, html} = live(conn, "/cookbooks")

      assert html =~ "2 recipes"
      assert html =~ "Indian"
      assert html =~ "Spicy"
      # First-seen unique ingredients are previewed.
      assert html =~ "chickpeas"
      assert html =~ "onion"
      # Card links to the cookbook detail page.
      assert html =~ "Open cookbook"
    end

    test "truncates the pantry preview to five unique ingredients with a +N more", %{
      conn: conn,
      user: user
    } do
      create_cookbook(user, "Big pantry", [
        %{name: "Stew", ingredients: ["a", "b", "c", "d", "e", "f", "g"]}
      ])

      {:ok, _view, html} = live(conn, "/cookbooks")

      assert html =~ "+2 more"
    end
  end

  describe "search" do
    test "filters by name, recipe name, ingredient and category (case-insensitive)", %{
      conn: conn,
      user: user
    } do
      create_cookbook(user, "Cozy soups", [
        %{name: "Minestrone", ingredients: ["cannellini beans"], category: "Comfort"}
      ])

      create_cookbook(user, "Sunday baking", [
        %{name: "Focaccia", ingredients: ["flour"], category: "Baking"}
      ])

      {:ok, view, _html} = live(conn, "/cookbooks")

      # by cookbook name
      html = render_change(view, "search", %{"query" => "cozy"})
      assert html =~ "Cozy soups"
      refute html =~ "Sunday baking"

      # by ingredient
      html = render_change(view, "search", %{"query" => "FLOUR"})
      assert html =~ "Sunday baking"
      refute html =~ "Cozy soups"

      # by category
      html = render_change(view, "search", %{"query" => "comfort"})
      assert html =~ "Cozy soups"
      refute html =~ "Sunday baking"
    end

    test "shows the no-results empty state and clears it", %{conn: conn, user: user} do
      create_cookbook(user, "Cozy soups")

      {:ok, view, _html} = live(conn, "/cookbooks")

      html = render_change(view, "search", %{"query" => "nonexistent"})
      assert html =~ "No cookbooks match"
      assert html =~ "Clear search"
      refute html =~ "Cozy soups"

      html = render_click(view, "clear_search")
      assert html =~ "Cozy soups"
      refute html =~ "No cookbooks match"
    end
  end

  describe "sort" do
    test "sorts by name A→Z", %{conn: conn, user: user} do
      create_cookbook(user, "Zucchini dishes")
      create_cookbook(user, "Apple bakes")

      {:ok, view, _html} = live(conn, "/cookbooks")

      html = render_click(view, "sort", %{"by" => "name"})

      assert text_index(html, "Apple bakes") < text_index(html, "Zucchini dishes")
    end

    test "sorts by most recipes first", %{conn: conn, user: user} do
      create_cookbook(user, "Few", [%{name: "One", ingredients: []}])

      create_cookbook(user, "Many", [
        %{name: "One", ingredients: []},
        %{name: "Two", ingredients: []},
        %{name: "Three", ingredients: []}
      ])

      {:ok, view, _html} = live(conn, "/cookbooks")

      html = render_click(view, "sort", %{"by" => "recipes"})

      assert text_index(html, "Many") < text_index(html, "Few")
    end
  end

  describe "empty state" do
    test "shows the first-run empty state and hides the toolbar", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/cookbooks")

      assert html =~ "You don&#39;t have any cookbooks yet!"
      refute html =~ "Search cookbooks, ingredients, tags"
    end
  end

  defp text_index(html, needle) do
    {index, _} = :binary.match(html, needle)
    index
  end
end
