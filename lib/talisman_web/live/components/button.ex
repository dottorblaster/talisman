defmodule TalismanWeb.Components.Button do
  @moduledoc """
  Button component
  """

  use Phoenix.Component

  attr :rest, :global
  slot :inner_block

  def button(assigns) do
    ~H"""
    <button
      class="inline-block w-full rounded-lg bg-orange-400 px-5 py-3 font-medium text-white sm:w-auto"
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
