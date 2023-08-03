defmodule TalismanWeb.Components.Button do
  @moduledoc """
  Button component
  """

  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def button(assigns) do
    ~H"""
    <button
      class={
        Tails.classes([
          "inline-block",
          "w-full",
          "rounded-lg",
          "bg-orange-400",
          "px-5",
          "py-3",
          "font-medium",
          "text-white",
          "sm:w-auto",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
