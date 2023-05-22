defmodule TalismanWeb.Components.Ingredient do
  @moduledoc """
  Single ingredient field live component
  """

  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <span>
      <input
        class="mt-2"
        type="text"
        value={@value}
        phx-change="update_ingredient"
        name={@id}
        phx-target={@myself}
      />
      <button type="button" phx-click="delete_ingredient" phx-target={@myself}>
        Delete
      </button>
    </span>
    """
  end

  def handle_event("update_ingredient", payload, socket) do
    %{assigns: %{id: id, index: index}} = socket
    value = Map.get(payload, id)

    send(self(), {:updated_ingredient, %{index: index, value: value}})

    {:noreply, socket}
  end

  def handle_event("delete_ingredient", _, socket) do
    %{assigns: %{index: index}} = socket

    send(self(), {:deleted_ingredient, %{index: index}})

    {:noreply, socket}
  end
end
