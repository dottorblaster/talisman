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
          "py-2",
          "font-semibold",
          "text-white",
          "sm:w-auto",
          "transition",
          "ease-in",
          "shadow-md",
          "focus:ring-2",
          "focus:ring-offset-2",
          "hover:bg-orange-500",
          "border-b-4",
          "border-orange-500",
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
