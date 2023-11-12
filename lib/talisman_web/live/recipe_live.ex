defmodule TalismanWeb.RecipeLive do
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  import TalismanWeb.Components.Button

  on_mount TalismanWeb.UserLiveAuth

  def mount(params, _session, socket) do
    recipe_id = Map.get(params, "recipe_id")
    recipe = Cookbooks.get_recipe!(recipe_id)

    {:ok, assign(socket, recipe: recipe, recipe_id: recipe_id)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <h1 class="mx-10 my-5 font-bold text-3xl"><%= @recipe.name %></h1>
        <div class="mx-10 mb-10"><%= @recipe.ingredients %></div>
        <div class="mx-10"><%= as_html(@recipe.recipe) %></div>
      </div>
      <div class="mx-10 mt-10">
        <.button phx-click="recipe_edit">Edit</.button>
      </div>
    </div>
    """
  end

  def handle_event(
        "recipe_edit",
        _payload,
        %{
          assigns: %{
            recipe_id: recipe_id
          }
        } = socket
      ),
      do: {:noreply, push_navigate(socket, to: ~p"/recipe/#{recipe_id}/edit")}

  defp as_html(markdown) do
    markdown |> Earmark.as_html!() |> raw
  end
end
