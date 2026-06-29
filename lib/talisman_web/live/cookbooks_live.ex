defmodule TalismanWeb.CookbooksLive do
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  import TalismanWeb.Components.Button

  on_mount TalismanWeb.UserLiveAuth

  @sorts %{"updated" => :updated, "name" => :name, "recipes" => :recipes}

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    cookbooks = Cookbooks.get_cookbooks_by_author_uuid(user_id)

    {:ok, assign(socket, cookbooks: cookbooks, query: "", sort: :updated)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, assign(socket, query: query)}
  end

  def handle_event("sort", %{"by" => by}, socket) do
    {:noreply, assign(socket, sort: Map.get(@sorts, by, :updated))}
  end

  def handle_event("clear_search", _params, socket) do
    {:noreply, assign(socket, query: "")}
  end

  def render(assigns) do
    assigns =
      assigns
      |> assign(:visible, filtered_sorted(assigns.cookbooks, assigns.query, assigns.sort))
      |> assign(:total_recipes, total_recipes(assigns.cookbooks))

    ~H"""
    <div class="mx-auto max-w-screen-xl px-4 pt-10 pb-20 sm:px-8 lg:px-20">
      <header class="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Your cookbooks</h1>
          <p class="mt-1 text-base text-gray-500">
            {length(@cookbooks)} {pluralize(length(@cookbooks), "cookbook")}
            <span class="text-gray-400">·</span>
            {@total_recipes} {pluralize(@total_recipes, "recipe")} in total
          </p>
        </div>

        <.link navigate={~p"/cookbooks/new"}>
          <.button class="inline-flex items-center gap-2">
            <.icon_folder_plus /> New cookbook
          </.button>
        </.link>
      </header>

      <div :if={@cookbooks != []} class="mt-8 flex flex-wrap items-center justify-between gap-4">
        <form phx-change="search" class="relative w-full max-w-[420px] grow">
          <span class="pointer-events-none absolute inset-y-0 left-3 flex items-center text-gray-400">
            <.icon_search />
          </span>
          <input
            type="text"
            name="query"
            value={@query}
            phx-debounce="200"
            autocomplete="off"
            placeholder="Search cookbooks, ingredients, tags…"
            class="w-full rounded-lg border-gray-200 bg-white py-2.5 pr-3.5 pl-[42px] text-sm shadow-md focus:border-blue-500 focus:ring-blue-500"
          />
        </form>

        <div class="flex items-center gap-2">
          <span class="text-sm text-gray-500">Sort</span>
          <div class="inline-flex gap-1 rounded-lg border border-gray-200 border-b-2 border-b-stone-300 bg-stone-100 p-[3px]">
            <.sort_button by="updated" active={@sort} label="Recently updated" />
            <.sort_button by="name" active={@sort} label="Name" />
            <.sort_button by="recipes" active={@sort} label="Most recipes" />
          </div>
        </div>
      </div>

      <div
        :if={@cookbooks == []}
        class="fade-in mx-auto flex max-w-md flex-col items-center py-[72px] text-center"
      >
        <div class="flex h-[72px] w-[72px] items-center justify-center rounded-full bg-orange-100 text-orange-600">
          <.icon_book_open />
        </div>
        <h2 class="mt-6 text-2xl font-bold text-gray-900">You don't have any cookbooks yet!</h2>
        <p class="mt-2 text-base text-gray-500">
          Create your first cookbook to start collecting recipes.
        </p>
        <.link navigate={~p"/cookbooks/new"} class="mt-6">
          <.button class="inline-flex items-center gap-2">
            <.icon_folder_plus /> New cookbook
          </.button>
        </.link>
      </div>

      <div
        :if={@cookbooks != [] and @visible == []}
        class="fade-in mx-auto flex max-w-md flex-col items-center py-[72px] text-center"
      >
        <div class="flex h-[72px] w-[72px] items-center justify-center rounded-full bg-gray-100 text-gray-400">
          <.icon_search />
        </div>
        <h2 class="mt-6 text-2xl font-bold text-gray-900">No cookbooks match "{@query}"</h2>
        <p class="mt-2 text-base text-gray-500">Try a different name, ingredient, or tag.</p>
        <.button intent="secondary" phx-click="clear_search" class="mt-6">Clear search</.button>
      </div>

      <div
        :if={@visible != []}
        class="fade-in mt-6 grid grid-cols-[repeat(auto-fill,minmax(330px,1fr))] gap-5"
      >
        <.link
          :for={cb <- @visible}
          navigate={~p"/cookbook/#{cb.uuid}"}
          class="flex h-full flex-col gap-4 rounded-lg border border-gray-300 border-b-2 bg-white p-8 shadow-lg transition hover:bg-stone-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        >
          <div class="flex items-start gap-[14px]">
            <div class="flex h-[46px] w-[46px] shrink-0 items-center justify-center rounded-lg border border-orange-200 bg-orange-100 text-orange-600">
              <.icon_book />
            </div>
            <div class="min-w-0">
              <h2 class="truncate text-xl font-semibold text-gray-900">{cb.name}</h2>
              <p class="text-sm text-gray-500">
                {cb.recipe_count} {pluralize(cb.recipe_count, "recipe")}
                <span class="text-gray-400">·</span> Updated {cb.relative_updated}
              </p>
            </div>
          </div>

          <div :if={cb.chips != []} class="flex flex-wrap gap-1.5">
            <span
              :for={chip <- cb.chips}
              class="rounded-full border border-orange-200 bg-orange-50 px-2.5 py-0.5 text-xs font-semibold text-orange-700"
            >
              {chip}
            </span>
          </div>

          <div class="mt-auto">
            <p class="text-xs font-semibold uppercase tracking-wide text-gray-400">In the pantry</p>
            <div class="mt-2 flex flex-wrap items-center gap-1.5">
              <span
                :for={ingredient <- cb.pantry}
                class="rounded-full bg-gray-200 px-3 py-1 text-xs text-gray-700"
              >
                {ingredient}
              </span>
              <span :if={cb.pantry_more > 0} class="text-xs font-semibold text-gray-500">
                +{cb.pantry_more} more
              </span>
            </div>
          </div>

          <span class="inline-flex items-center gap-1 text-sm font-semibold text-orange-500">
            Open cookbook <.icon_arrow_right />
          </span>
        </.link>
      </div>
    </div>
    """
  end

  attr :by, :string, required: true
  attr :label, :string, required: true
  attr :active, :atom, required: true

  defp sort_button(assigns) do
    assigns = assign(assigns, :is_active, to_string(assigns.active) == assigns.by)

    ~H"""
    <button
      type="button"
      phx-click="sort"
      phx-value-by={@by}
      class={[
        "rounded-md px-3 py-1.5 text-sm font-semibold transition",
        if(@is_active,
          do: "bg-white text-gray-900 shadow-md",
          else: "text-gray-500 hover:text-gray-700"
        )
      ]}
    >
      {@label}
    </button>
    """
  end

  # --- Server-side derivations -------------------------------------------------

  defp filtered_sorted(cookbooks, query, sort) do
    cookbooks
    |> Enum.map(&present/1)
    |> filter(query)
    |> sort(sort)
  end

  defp present(cookbook) do
    {pantry, more} = pantry(cookbook.recipes)

    %{
      uuid: cookbook.uuid,
      name: cookbook.name,
      recipe_count: length(cookbook.recipes),
      chips: chips(cookbook.recipes),
      pantry: pantry,
      pantry_more: more,
      updated_at: last_updated(cookbook),
      relative_updated: relative_time(last_updated(cookbook)),
      haystack: haystack(cookbook)
    }
  end

  defp filter(cookbooks, query) do
    case String.trim(query) do
      "" ->
        cookbooks

      term ->
        term = String.downcase(term)
        Enum.filter(cookbooks, &String.contains?(&1.haystack, term))
    end
  end

  defp sort(cookbooks, :name), do: Enum.sort_by(cookbooks, &String.downcase(&1.name))
  defp sort(cookbooks, :recipes), do: Enum.sort_by(cookbooks, & &1.recipe_count, :desc)

  defp sort(cookbooks, :updated),
    do: Enum.sort_by(cookbooks, & &1.updated_at, {:desc, NaiveDateTime})

  # Distinct, non-empty recipe categories in first-seen order.
  defp chips(recipes) do
    recipes
    |> Enum.map(& &1.category)
    |> Enum.reject(&(is_nil(&1) or &1 == ""))
    |> Enum.uniq()
  end

  # First 5 distinct ingredients across the cookbook's recipes + remainder count.
  defp pantry(recipes) do
    unique =
      recipes
      |> Enum.flat_map(&(&1.ingredients || []))
      |> Enum.reject(&(is_nil(&1) or &1 == ""))
      |> Enum.uniq()

    {Enum.take(unique, 5), max(length(unique) - 5, 0)}
  end

  # Most recent recipe timestamp, falling back to the cookbook's own.
  defp last_updated(cookbook) do
    cookbook.recipes
    |> Enum.map(& &1.updated_at)
    |> Enum.reject(&is_nil/1)
    |> Enum.max(NaiveDateTime, fn -> cookbook.updated_at end)
  end

  defp haystack(cookbook) do
    [
      cookbook.name
      | Enum.flat_map(cookbook.recipes, fn recipe ->
          [recipe.name, recipe.category | recipe.ingredients || []]
        end)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
    |> String.downcase()
  end

  defp total_recipes(cookbooks), do: Enum.sum(Enum.map(cookbooks, &length(&1.recipes)))

  defp pluralize(1, word), do: word
  defp pluralize(_n, word), do: word <> "s"

  defp relative_time(nil), do: "recently"

  defp relative_time(datetime) do
    days = NaiveDateTime.diff(NaiveDateTime.utc_now(), datetime, :day)

    cond do
      days <= 0 -> "today"
      days == 1 -> "yesterday"
      days < 7 -> "#{days} days ago"
      days < 14 -> "last week"
      days < 30 -> "#{div(days, 7)} weeks ago"
      days < 60 -> "last month"
      true -> "#{div(days, 30)} months ago"
    end
  end

  # --- Inline Heroicons (outline, stroke-width 1.5) ----------------------------

  attr :class, :string, default: "h-6 w-6"

  defp icon_book(assigns) do
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
        d="M16.5 3.75V16.5L12 14.25 7.5 16.5V3.75m9 0H18A2.25 2.25 0 0120.25 6v12A2.25 2.25 0 0118 20.25H6A2.25 2.25 0 013.75 18V6A2.25 2.25 0 016 3.75h1.5m9 0h-9"
      />
    </svg>
    """
  end

  attr :class, :string, default: "h-8 w-8"

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

  attr :class, :string, default: "h-5 w-5"

  defp icon_folder_plus(assigns) do
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
        d="M12 10.5v6m3-3H9m4.06-7.19l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"
      />
    </svg>
    """
  end

  attr :class, :string, default: "h-5 w-5"

  defp icon_search(assigns) do
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
        d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"
      />
    </svg>
    """
  end

  attr :class, :string, default: "h-4 w-4"

  defp icon_arrow_right(assigns) do
    ~H"""
    <svg
      class={@class}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
    >
      <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
    </svg>
    """
  end
end
