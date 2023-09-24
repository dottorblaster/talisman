defmodule TalismanWeb.NewRecipeLive do
  require Logger
  use TalismanWeb, :live_view

  alias Phoenix.HTML.Form
  alias Talisman.Cookbooks
  alias TalismanWeb.Components.Ingredient

  import TalismanWeb.Components.Button
  import TalismanWeb.Components.Container
  import TalismanWeb.Components.FormError
  import TalismanWeb.Components.Input

  on_mount TalismanWeb.UserLiveAuth

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    cookbooks = Cookbooks.get_cookbooks_by_author_uuid(user_id)
    first_cookbook_id = get_first_cookbook_id(cookbooks)

    {:ok,
     socket
     |> assign(cookbooks: cookbooks)
     |> assign(cookbook_id: first_cookbook_id)
     |> assign(name: "")
     |> assign(ingredients: [])
     |> assign(recipe: "")
     |> assign(errors: %{})}
  end

  def render(%{cookbooks: []} = assigns) do
    ~H"""
    <.container>
      <p class="mb-5">You need to create a cookbook first!</p>
      <.button phx-click="navigate_create_cookbook">Jump to cookbook creation</.button>
    </.container>
    """
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
          <.form_error class="mt-1" errors={@errors} key={:name} />
        </div>

        <div>
          <select name="cookbook" id="cookbook" phx-change="update_cookbook_id">
            <%= for cookbook <- assigns.cookbooks do %>
              <option value={cookbook.uuid} selected={selected_attr(cookbook.uuid, @cookbook_id)}>
                <%= cookbook.name %>
              </option>
            <% end %>
          </select>
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
          <.form_error errors={@errors} key={:recipe} />
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

  def handle_event("navigate_create_cookbook", _, socket) do
    {:noreply, push_navigate(socket, to: ~p"/cookbooks/new")}
  end

  def handle_event(
        "save",
        _,
        %{
          assigns: %{
            cookbook_id: cookbook_id,
            recipe: recipe,
            ingredients: ingredients,
            name: name,
            current_user: %{id: user_id}
          }
        } = socket
      ) do
    result =
      Cookbooks.add_recipe(%{
        cookbook_uuid: cookbook_id,
        author_uuid: user_id,
        recipe: recipe,
        name: name,
        ingredients: ingredients,
        category: ""
      })

    new_socket =
      case result do
        :ok ->
          socket

        {:error, errors} ->
          Logger.error("Error saving new recipe: #{inspect(errors)}")
          assign(socket, errors: errors)
      end

    {:noreply, new_socket}
  end

  defp selected_attr(attr, attr),
    do: true

  defp selected_attr(_, _), do: false

  defp get_first_cookbook_id([]), do: nil
  defp get_first_cookbook_id(cookbooks), do: cookbooks |> List.first() |> Map.get(:uuid)
end
