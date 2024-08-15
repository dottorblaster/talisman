defmodule TalismanWeb.Components.FormError do
  @moduledoc """
  Button component
  """

  use Phoenix.Component

  attr :class, :string, default: nil
  attr :errors, :map, default: %{}
  attr :key, :atom, default: nil
  attr :rest, :global
  slot :inner_block

  def form_error(assigns) do
    if Map.has_key?(assigns.errors, assigns.key) do
      ~H"""
      <p
        class={
          Tails.classes([
            "text-sm",
            "text-red-500",
            @class
          ])
        }
        {@rest}
      >
        <%= Map.get(@errors, @key, "") %>
      </p>
      """
    else
      ~H"""
      """
    end
  end
end
