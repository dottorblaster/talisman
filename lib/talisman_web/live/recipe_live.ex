defmodule TalismanWeb.RecipeLive do
  require Logger
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  import TalismanWeb.Components.{Button, Modal}

  on_mount TalismanWeb.UserLiveAuth

  def mount(params, _session, socket) do
    recipe_id = Map.get(params, "recipe_id")
    recipe = Cookbooks.get_recipe!(recipe_id)

    {:ok,
     socket
     |> assign(recipe: recipe, recipe_id: recipe_id, deletion_modal_visible: false)
     |> assign(ingredients_checked: MapSet.new())
     |> assign_recipe_derived(recipe)}
  end

  def render(assigns) do
    ~H"""
    <main class="max-w-screen-xl mx-auto px-6 pt-10 pb-20 sm:px-10">
      <div class="flex items-center gap-2 text-orange-600 text-[13px] font-semibold tracking-wide uppercase mb-4">
        <.icon_book_open class="h-4 w-4" />
        {@cookbook_name}
      </div>

      <h1 class="font-bold text-[42px] leading-[1.08] tracking-tight text-gray-900 m-0">
        {@recipe.name}
      </h1>

      <p :if={@intro} class="max-w-[640px] mt-4 text-lg leading-relaxed text-gray-500">
        {raw(@intro)}
      </p>

      <hr class="border-0 border-t border-gray-200 mt-8 mb-10" />

      <div class="grid grid-cols-1 lg:grid-cols-[320px_1fr] gap-14 items-start">
        <aside class="lg:sticky lg:top-6 bg-orange-50 border border-orange-200 border-b-2 border-b-orange-300 rounded-lg p-7 shadow-lg">
          <h2 class="text-xl font-bold text-gray-900 m-0">Ingredients</h2>
          <div class="text-[13px] font-semibold text-orange-700 mt-[5px]">
            {@gathered} of {@total} gathered
          </div>

          <div class="h-1.5 rounded-full bg-orange-100 mt-3.5 overflow-hidden">
            <div
              class="h-full rounded-full bg-orange-400 transition-[width] duration-[250ms] ease-out"
              style={"width: #{@pct}%"}
            >
            </div>
          </div>

          <div class="mt-[18px] flex flex-col">
            <button
              :for={{ingredient, index} <- Enum.with_index(@recipe.ingredients)}
              phx-click="toggle_ingredient"
              phx-value-index={index}
              class="w-full flex items-center gap-[13px] py-[11px] px-0.5 border-b border-orange-100 cursor-pointer text-left"
            >
              <%= if MapSet.member?(@ingredients_checked, index) do %>
                <span class="w-[22px] h-[22px] rounded-md border-2 border-orange-500 bg-orange-400 shrink-0 flex items-center justify-center">
                  <svg
                    class="h-3 w-3 text-white"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="3"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                  </svg>
                </span>
                <span class="text-[15px] leading-snug text-gray-400 line-through">{ingredient}</span>
              <% else %>
                <span class="w-[22px] h-[22px] rounded-md border-2 border-orange-300 bg-white shrink-0">
                </span>
                <span class="text-[15px] leading-snug text-gray-700">{ingredient}</span>
              <% end %>
            </button>
          </div>
        </aside>

        <section>
          <div class="flex items-baseline gap-2.5 mb-[22px]">
            <h2 class="text-2xl font-bold text-gray-900 m-0">Method</h2>
            <span class="text-sm text-gray-400 font-medium">{@step_count} steps</span>
          </div>

          <div class="flex flex-col gap-[26px]">
            <div :for={{step, index} <- Enum.with_index(@steps)} class="flex gap-[18px] items-start">
              <span class="w-10 h-10 rounded-full bg-orange-100 border-b-2 border-b-orange-200 text-orange-700 flex items-center justify-center font-bold text-[17px] shrink-0">
                {index + 1}
              </span>
              <p class="m-0 pt-[7px] text-[17px] leading-relaxed text-gray-700">{raw(step)}</p>
            </div>
          </div>

          <div
            :if={@tip}
            class="mt-9 bg-orange-50 border border-orange-200 border-b-2 border-b-orange-300 rounded-lg px-6 py-5"
          >
            <div class="text-xs font-bold tracking-wider uppercase text-orange-600">Tip</div>
            <div class="mt-2 text-[15px] leading-relaxed text-gray-700">{raw(@tip)}</div>
          </div>

          <div class="flex gap-3 mt-10">
            <.button phx-click="recipe_edit">
              <span class="inline-flex items-center gap-2">
                <.icon_pencil_square class="h-[18px] w-[18px]" /> Edit
              </span>
            </.button>
            <.button intent="secondary" phx-click="show_deletion_modal">
              <span class="inline-flex items-center gap-2">
                <.icon_trash class="h-[18px] w-[18px]" /> Delete
              </span>
            </.button>
          </div>
        </section>
      </div>

      <.modal title="Delete recipe" type="warning" open={@deletion_modal_visible}>
        Are you sure you want to delete this recipe?
        <:footer>
          <.button class="mx-1" phx-click="recipe_delete">Delete</.button>
          <.button intent="secondary" phx-click="hide_deletion_modal">Cancel</.button>
        </:footer>
      </.modal>
    </main>
    """
  end

  def handle_event("toggle_ingredient", %{"index" => index}, socket) do
    index = String.to_integer(index)
    checked = socket.assigns.ingredients_checked

    checked =
      if MapSet.member?(checked, index),
        do: MapSet.delete(checked, index),
        else: MapSet.put(checked, index)

    {:noreply, socket |> assign(ingredients_checked: checked) |> assign_progress()}
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

  # --- Derived assigns --------------------------------------------------------

  defp assign_recipe_derived(socket, recipe) do
    cookbook = Cookbooks.get_cookbook(recipe.cookbook_uuid)
    %{intro: intro, steps: steps, tip: tip} = parse_recipe(recipe.recipe)

    socket
    |> assign(cookbook_name: cookbook_name(cookbook))
    |> assign(intro: intro, steps: steps, tip: tip, step_count: length(steps))
    |> assign_progress()
  end

  defp assign_progress(socket) do
    total = length(socket.assigns.recipe.ingredients)
    gathered = MapSet.size(socket.assigns.ingredients_checked)
    pct = if total > 0, do: round(gathered / total * 100), else: 0

    assign(socket, gathered: gathered, total: total, pct: pct)
  end

  defp cookbook_name(%{name: name}), do: name
  defp cookbook_name(_), do: nil

  # --- Markdown -> structured content -----------------------------------------
  #
  # Judgment call (no schema migration): the Markdown body is parsed into an AST
  # and split into Method steps, an optional intro, and an optional Tip.
  #
  #   * Tip   <- the first blockquote (`>`), if any.
  #   * Steps <- ordered/unordered list items when the body has a list; otherwise
  #              every top-level paragraph becomes its own step (paragraph-per-step).
  #   * Intro <- the first leading paragraph, but only when the steps came from a
  #              list. When there is no list the paragraphs are themselves the
  #              steps, so we omit the intro to avoid duplicating the first step.
  #
  # Inline Markdown (`**bold**` / `*italic*` / `` `code` ``) is preserved by
  # transforming each block's inline children back to HTML.
  defp parse_recipe(markdown) do
    ast =
      case Earmark.Parser.as_ast(markdown || "") do
        {:ok, ast, _} -> ast
        {:error, ast, _} -> ast
      end

    tip =
      Enum.find_value(ast, fn
        {"blockquote", _, children, _} -> render_blockquote(children)
        _ -> nil
      end)

    list_items =
      Enum.find_value(ast, fn
        {tag, _, items, _} when tag in ["ol", "ul"] -> items
        _ -> nil
      end)

    paragraphs = Enum.filter(ast, &match?({"p", _, _, _}, &1))

    {intro, steps} =
      case list_items do
        nil ->
          {nil, Enum.map(paragraphs, &render_inline/1)}

        items ->
          intro = paragraphs |> List.first() |> render_inline()
          {intro, Enum.map(items, &render_inline/1)}
      end

    %{intro: intro, steps: steps, tip: tip}
  end

  defp render_inline(nil), do: nil

  defp render_inline({_tag, _attrs, children, _meta}),
    do: children |> Earmark.Transform.transform() |> String.trim()

  defp render_blockquote(children) do
    children
    |> Enum.flat_map(fn
      {"p", _, inline, _} -> inline
      other -> [other]
    end)
    |> Earmark.Transform.transform()
    |> String.trim()
  end

  # --- Inline Heroicons (outline, stroke-width 1.5) ----------------------------

  attr :class, :string, default: "h-6 w-6"

  defp icon_book_open(assigns) do
    ~H"""
    <svg
      class={@class}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25"
      />
    </svg>
    """
  end

  attr :class, :string, default: "h-6 w-6"

  defp icon_pencil_square(assigns) do
    ~H"""
    <svg
      class={@class}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10"
      />
    </svg>
    """
  end

  attr :class, :string, default: "h-6 w-6"

  defp icon_trash(assigns) do
    ~H"""
    <svg
      class={@class}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.02-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
      />
    </svg>
    """
  end
end
