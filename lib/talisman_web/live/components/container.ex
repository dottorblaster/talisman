defmodule TalismanWeb.Components.Container do
  @moduledoc """
  Just some shorthands to avoid markup repetition for containers
  """

  use Phoenix.Component

  slot :inner_block, required: true

  def container(assigns) do
    ~H"""
    <section class="">
      <div class="mx-auto max-w-screen-xl max-h-full px-4 py-16 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 gap-x-16 gap-y-8 lg:grid-cols-5">
          <div class="rounded-lg bg-white p-8 border-gray200 border shadow-lg lg:col-span-3 lg:p-12">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
