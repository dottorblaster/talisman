defmodule TalismanWeb.RecipeControllerTest do
  use TalismanWeb.ConnCase

  import Talisman.CookbookFixtures

  alias Talisman.Cookbook.Recipe

  @create_attrs %{
    author_bio: "some author_bio",
    author_image: "some author_image",
    author_username: "some author_username",
    author_uuid: "some author_uuid",
    body: "some body",
    description: "some description",
    favorite_count: 42,
    ingredients: [],
    published_at: ~N[2022-12-25 11:51:00],
    slug: "some slug",
    title: "some title"
  }
  @update_attrs %{
    author_bio: "some updated author_bio",
    author_image: "some updated author_image",
    author_username: "some updated author_username",
    author_uuid: "some updated author_uuid",
    body: "some updated body",
    description: "some updated description",
    favorite_count: 43,
    ingredients: [],
    published_at: ~N[2022-12-26 11:51:00],
    slug: "some updated slug",
    title: "some updated title"
  }
  @invalid_attrs %{author_bio: nil, author_image: nil, author_username: nil, author_uuid: nil, body: nil, description: nil, favorite_count: nil, ingredients: nil, published_at: nil, slug: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      conn = get(conn, Routes.recipe_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipe" do
    test "renders recipe when data is valid", %{conn: conn} do
      conn = post(conn, Routes.recipe_path(conn, :create), recipe: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.recipe_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "author_bio" => "some author_bio",
               "author_image" => "some author_image",
               "author_username" => "some author_username",
               "author_uuid" => "some author_uuid",
               "body" => "some body",
               "description" => "some description",
               "favorite_count" => 42,
               "ingredients" => [],
               "published_at" => "2022-12-25T11:51:00",
               "slug" => "some slug",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipe_path(conn, :create), recipe: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "renders recipe when data is valid", %{conn: conn, recipe: %Recipe{id: id} = recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.recipe_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "author_bio" => "some updated author_bio",
               "author_image" => "some updated author_image",
               "author_username" => "some updated author_username",
               "author_uuid" => "some updated author_uuid",
               "body" => "some updated body",
               "description" => "some updated description",
               "favorite_count" => 43,
               "ingredients" => [],
               "published_at" => "2022-12-26T11:51:00",
               "slug" => "some updated slug",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn = delete(conn, Routes.recipe_path(conn, :delete, recipe))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipe_path(conn, :show, recipe))
      end
    end
  end

  defp create_recipe(_) do
    recipe = recipe_fixture()
    %{recipe: recipe}
  end
end
