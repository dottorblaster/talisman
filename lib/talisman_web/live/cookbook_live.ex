defmodule TalismanWeb.CookbookLive do
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  on_mount TalismanWeb.UserLiveAuth

  def mount(params, _session, socket) do
    cookbook_id = Map.get(params, "cookbook_id")
    cookbook = Cookbooks.get_cookbook(cookbook_id)

    {:ok, assign(socket, cookbook: cookbook)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="mb-5"><%= @cookbook.name %></h1>

      <div class="">
        <%= for recipe <- @cookbook.recipes do %>
          <div class="w-96 rounded overflow-hidden shadow-lg mx-6 inline-block">
            <div class="px-6 py-4">
              <div class="font-bold text-xl mb-2">
                <a href={"/recipe/#{recipe.uuid}"}><%= recipe.name %></a>
              </div>
              <p class="text-gray-700 text-base">
                <%= render_preview(recipe.recipe) %>
              </p>
            </div>
            <div class="px-6 pt-4 pb-2">
              <%= for ingredient <- recipe.ingredients do %>
                <span class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2">
                  <%= ingredient %>
                </span>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp render_preview(recipe) do
    case String.length(recipe) < 201 do
      true ->
        recipe

      false ->
        preview = String.slice(recipe, 0..200)
        "#{preview} ..."
    end
  end
end
