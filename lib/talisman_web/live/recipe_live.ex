defmodule TalismanWeb.RecipeLive do
  require Logger
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  import TalismanWeb.Components.{Button, Modal}

  on_mount TalismanWeb.UserLiveAuth

  def mount(params, _session, socket) do
    recipe_id = Map.get(params, "recipe_id")
    recipe = Cookbooks.get_recipe!(recipe_id)

    {:ok, assign(socket, recipe: recipe, recipe_id: recipe_id, deletion_modal_visible: false)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <h1 class="mx-10 my-5 font-bold text-3xl"><%= @recipe.name %></h1>
        <div class="mx-10 mb-10">
          <%= for ingredient <- @recipe.ingredients do %>
            <div>
              <span class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2">
                <%= ingredient %>
              </span>
            </div>
          <% end %>
        </div>
        <div class="mx-10"><%= as_html(@recipe.recipe) %></div>
      </div>
      <div class="mx-10 mt-10">
        <.button phx-click="recipe_edit">Edit</.button>
        <.button phx-click="show_deletion_modal">Delete</.button>
      </div>
      <.modal title="Delete recipe" type="warning" open={@deletion_modal_visible}>
        Are you sure you want to delete this recipe?
        <:footer>
          <.button class="mx-1" phx-click="recipe_delete">Delete</.button>
          <.button intent="secondary" phx-click="hide_deletion_modal">Cancel</.button>
        </:footer>
      </.modal>
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

  def handle_event("show_deletion_modal", _payload, socket),
    do: {:noreply, assign(socket, deletion_modal_visible: true)}

  def handle_event("hide_deletion_modal", _payload, socket),
    do: {:noreply, assign(socket, deletion_modal_visible: false)}

  def handle_event(
        "recipe_delete",
        _,
        %{assigns: %{recipe: recipe, recipe_id: recipe_id, current_user: %{id: user_id}}} = socket
      ) do
    result =
      Cookbooks.delete_recipe(user_id, %{
        recipe_uuid: recipe_id,
        cookbook_uuid: recipe.cookbook_uuid
      })

    new_socket =
      case result do
        {:error, :cookbook_pemission_denied} ->
          Logger.error("Trying to edit recipe but permission to the cookbook was denied.")
          socket

        {:error, errors} ->
          assign(socket, errors: errors)

        :ok ->
          push_navigate(socket, to: ~p"/cookbook/#{recipe.cookbook_uuid}")
      end

    {:noreply, new_socket}
  end

  defp as_html(markdown) do
    markdown |> Earmark.as_html!() |> raw
  end
end
