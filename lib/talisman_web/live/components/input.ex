defmodule TalismanWeb.Components.Input do
  @moduledoc """
  Input component
  """

  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(name value)
  slot :inner_block

  def input(assigns) do
    ~H"""
    <input
      class={
        Tails.classes([
          "rounded-lg",
          "border-gray-200",
          "p-3",
          "text-sm",
          @class
        ])
      }
      {@rest}
    />
    """
  end
end
