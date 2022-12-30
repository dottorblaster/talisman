defmodule TalismanWeb.RecipeView do
  use TalismanWeb, :view
  alias TalismanWeb.RecipeView

  def render("index.json", %{recipes: recipes}) do
    %{data: render_many(recipes, RecipeView, "recipe.json")}
  end

  def render("show.json", %{recipe: recipe}) do
    %{data: render_one(recipe, RecipeView, "recipe.json")}
  end

  def render("recipe.json", %{recipe: recipe}) do
    %{
      id: recipe.id,
      slug: recipe.slug,
      title: recipe.title,
      description: recipe.description,
      body: recipe.body,
      ingredients: recipe.ingredients,
      favorite_count: recipe.favorite_count,
      published_at: recipe.published_at,
      author_uuid: recipe.author_uuid,
      author_username: recipe.author_username,
      author_bio: recipe.author_bio,
      author_image: recipe.author_image
    }
  end
end
