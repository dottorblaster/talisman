defmodule TalismanWeb.NewRecipeLive do
  use TalismanWeb, :live_view

  alias Phoenix.HTML.Form
  alias Talisman.Cookbooks
  alias TalismanWeb.Components.Ingredient

  on_mount TalismanWeb.UserLiveAuth

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    cookbooks = Cookbooks.get_cookbooks_by_author_uuid(user_id)

    {:ok,
     socket
     |> assign(cookbooks: cookbooks)
     |> assign(name: "")
     |> assign(ingredients: [])
     |> assign(recipe: "")}
  end

  def render(assigns) do
    ~H"""
    <section class="">
      <div class="mx-auto max-w-screen-xl max-h-full px-4 py-16 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 gap-x-16 gap-y-8 lg:grid-cols-5">
          <div class="rounded-lg bg-white p-8 border-gray200 border shadow-lg lg:col-span-3 lg:p-12">

            <form phx-submit="save" class="space-y-4">
              <div>
                <label class="sr-only" for="name">Name</label>
                <input
                  name="name"
                  class="w-full rounded-lg border-gray-200 p-3 text-sm"
                  placeholder="Name"
                  type="text"
                  id="name"
                  phx-change="update_name"
                  value={Form.normalize_value("text", assigns.name)}
                />
              </div>

              <div>
                <label for="Description" class="block text-sm text-gray-500 dark:text-gray-300">Write down your recipe!</label>

                <textarea name="recipe" placeholder="lorem..." class="block  mt-2 w-full placeholder-gray-400/70 dark:placeholder-gray-500 rounded-lg border border-gray-200 bg-white px-4 h-96 py-2.5 text-gray-700 focus:border-blue-400 focus:outline-none focus:ring focus:ring-blue-300 focus:ring-opacity-40 dark:border-gray-600 dark:bg-gray-900 dark:text-gray-300 dark:focus:border-blue-300" phx-change="update_recipe"><%= Form.normalize_value("text", assigns.recipe) %></textarea>
                  
                <p class="mt-3 text-xs text-gray-400 dark:text-gray-600">Lorem ipsum dolor sit amet consectetur adipisicing elit.</p>
              </div>

              <div class="mt-4">
                <%= for {ingredient, index} <- Enum.with_index(assigns.ingredients) do %>
                  <.live_component module={Ingredient} value={ingredient} index={index} id={"ingredient-#{index}"} />
                <% end %>
              </div>

              <div class="mt-4">
                <button phx-click="add_ingredient" type="button">Add ingredient</button>
              </div>

              <div class="mt-4">
                <button
                  type="submit"
                  class="inline-block w-full rounded-lg bg-orange-400 px-5 py-3 font-medium text-white sm:w-auto"
                >
                  Save recipe
                </button>
              </div>
            </form>

          </div>
        </div>
      </div>
    </section>
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

  def handle_event(
        "save",
        _,
        %{
          assigns: %{
            recipe: recipe,
            ingredients: ingredients,
            name: name,
            current_user: %{id: user_id}
          }
        } = socket
      ) do
    {:noreply, socket}
  end
end
