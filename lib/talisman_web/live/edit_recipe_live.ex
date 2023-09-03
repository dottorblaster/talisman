defmodule TalismanWeb.EditRecipeLive do
  use TalismanWeb, :live_view

  alias Phoenix.HTML.Form
  alias Talisman.Cookbooks
  alias TalismanWeb.Components.Ingredient

  import TalismanWeb.Components.Button
  import TalismanWeb.Components.Container
  import TalismanWeb.Components.Input

  on_mount TalismanWeb.UserLiveAuth

  def mount(params, _session, socket) do
    recipe_id = Map.get(params, "recipe_id")
    recipe = Cookbooks.get_recipe!(recipe_id)

    {:ok,
     socket
     |> assign(cookbook_uuid: recipe.cookbook_uuid)
     |> assign(recipe_uuid: recipe_id)
     |> assign(name: recipe.name)
     |> assign(ingredients: recipe.ingredients)
     |> assign(recipe: recipe.recipe)}
  end

  def render(assigns) do
    ~H"""
    <.container>
      <form phx-submit="save" class="space-y-4">
        <div>
          <label class="sr-only" for="name">Name</label>
          <.input
            class="w-full"
            type="text"
            name="name"
            placeholder="Name"
            id="name"
            phx-change="update_name"
            value={Form.normalize_value("text", assigns.name)}
          />
        </div>

        <div>
          <label for="Description" class="block text-sm text-gray-500 dark:text-gray-300">
            Write down your recipe!
          </label>

          <textarea
            name="recipe"
            placeholder="lorem..."
            class="block  mt-2 w-full placeholder-gray-400/70 dark:placeholder-gray-500 rounded-lg border border-gray-200 bg-white px-4 h-96 py-2.5 text-gray-700 focus:border-blue-400 focus:outline-none focus:ring focus:ring-blue-300 focus:ring-opacity-40 dark:border-gray-600 dark:bg-gray-900 dark:text-gray-300 dark:focus:border-blue-300"
            phx-change="update_recipe"
          ><%= Form.normalize_value("text", assigns.recipe) %></textarea>

          <p class="mt-3 text-xs text-gray-400 dark:text-gray-600">
            Lorem ipsum dolor sit amet consectetur adipisicing elit.
          </p>
        </div>

        <div class="mt-4">
          <%= for {ingredient, index} <- Enum.with_index(assigns.ingredients) do %>
            <.live_component
              module={Ingredient}
              value={ingredient}
              index={index}
              id={"ingredient-#{index}"}
            />
          <% end %>
        </div>

        <div class="mt-4">
          <.button phx-click="add_ingredient" type="button">Add ingredient</.button>
        </div>

        <div class="mt-4">
          <.button type="submit">
            Save recipe
          </.button>
        </div>
      </form>
    </.container>
    """
  end

  def handle_info({:updated_ingredient, %{index: index, value: value}}, socket),
    do:
      {:noreply,
       assign(socket, ingredients: List.replace_at(socket.assigns.ingredients, index, value))}

  def handle_info({:deleted_ingredient, %{index: index}}, socket) do
    {:noreply, assign(socket, ingredients: List.delete_at(socket.assigns.ingredients, index))}
  end

  def handle_event("add_ingredient", _, socket) do
    {:noreply, assign(socket, ingredients: socket.assigns.ingredients ++ [""])}
  end

  def handle_event("update_name", %{"name" => name}, socket) do
    {:noreply, assign(socket, name: name)}
  end

  def handle_event("update_recipe", %{"recipe" => recipe}, socket) do
    {:noreply, assign(socket, recipe: recipe)}
  end

  def handle_event("update_cookbook_id", %{"cookbook" => cookbook}, socket) do
    {:noreply, assign(socket, cookbook_id: cookbook)}
  end

  def handle_event(
        "save",
        _,
        %{
          assigns: %{
            cookbook_uuid: cookbook_uuid,
            recipe_uuid: recipe_uuid,
            recipe: recipe,
            ingredients: ingredients,
            name: name,
            current_user: %{id: user_id}
          }
        } = socket
      ) do
    :ok =
      Cookbooks.edit_recipe(user_id, %{
        cookbook_uuid: cookbook_uuid,
        recipe_uuid: recipe_uuid,
        name: name,
        recipe: recipe,
        ingredients: ingredients,
        category: ""
      })

    {:noreply, socket}
  end
end
