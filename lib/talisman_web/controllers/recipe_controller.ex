defmodule TalismanWeb.RecipeController do
  use TalismanWeb, :controller

  alias Talisman.Cookbook
  alias Talisman.Cookbook.Recipe

  action_fallback TalismanWeb.FallbackController

  def index(conn, _params) do
    recipes = Cookbook.list_recipes()
    render(conn, "index.json", recipes: recipes)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    with {:ok, %Recipe{} = recipe} <- Cookbook.create_recipe(recipe_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.recipe_path(conn, :show, recipe))
      |> render("show.json", recipe: recipe)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Cookbook.get_recipe!(id)
    render(conn, "show.json", recipe: recipe)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Cookbook.get_recipe!(id)

    with {:ok, %Recipe{} = recipe} <- Cookbook.update_recipe(recipe, recipe_params) do
      render(conn, "show.json", recipe: recipe)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Cookbook.get_recipe!(id)

    with {:ok, %Recipe{}} <- Cookbook.delete_recipe(recipe) do
      send_resp(conn, :no_content, "")
    end
  end
end
