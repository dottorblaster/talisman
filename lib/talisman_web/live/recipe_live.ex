defmodule TalismanWeb.RecipeLive do
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  on_mount TalismanWeb.UserLiveAuth

  def mount(params, _session, socket) do
    recipe_id = Map.get(params, "recipe_id")
    recipe = Cookbooks.get_recipe!(recipe_id)

    {:ok, assign(socket, recipe: recipe)}
  end

  def render(assigns) do
    ~H"""
    <span>
      <h1><%= @recipe.name %></h1>
      <div><%= @recipe.ingredients %></div>
      <div><%= @recipe.recipe %></div>
    </span>
    """
  end
end
