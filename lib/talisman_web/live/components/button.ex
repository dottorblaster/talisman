defmodule TalismanWeb.Components.Button do
  @moduledoc """
  Button component
  """

  use Phoenix.Component

  attr :class, :string, default: nil
  attr :type, :string, default: "primary"
  attr :rest, :global
  slot :inner_block

  def button(assigns) do
    ~H"""
    <button class={Tails.classes(get_button_classes(@type) ++ [@class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  defp get_button_classes("primary"),
    do: [
      "inline-block",
      "rounded-lg",
      "bg-orange-400",
      "px-5",
      "py-2",
      "font-semibold",
      "text-white",
      "transition",
      "ease-in",
      "shadow-md",
      "focus:ring-2",
      "focus:ring-offset-2",
      "hover:bg-orange-500",
      "border-b-4",
      "border-orange-500"
    ]

  defp get_button_classes("secondary"),
    do: [
      "inline-block",
      "rounded-lg",
      "bg-stone-200",
      "px-5",
      "py-2",
      "font-semibold",
      "text-neutral-700",
      "transition",
      "ease-in",
      "shadow-md",
      "focus:ring-2",
      "focus:ring-offset-2",
      "hover:bg-stone-300",
      "border-b-4",
      "border-stone-400"
    ]

  defp get_button_classes(_),
    do: [
      "inline-block",
      "rounded-lg",
      "bg-orange-400",
      "px-5",
      "py-2",
      "font-semibold",
      "text-white",
      "transition",
      "ease-in",
      "shadow-md",
      "focus:ring-2",
      "focus:ring-offset-2",
      "hover:bg-orange-500",
      "border-b-4",
      "border-orange-500"
    ]
end
