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
      <h1 class="mx-10 my-5 font-bold text-3xl"><%= @recipe.name %></h1>
      <div class="mx-10 mb-10"><%= @recipe.ingredients %></div>
      <div class="mx-10"><%= as_html(@recipe.recipe) %></div>
    </span>
    """
  end

  defp as_html(markdown) do
    markdown |> Earmark.as_html!() |> raw
  end
end
