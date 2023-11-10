defmodule TalismanWeb.CookbooksLive do
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  on_mount TalismanWeb.UserLiveAuth

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    cookbooks = Cookbooks.get_cookbooks_by_author_uuid(user_id)

    {:ok, assign(socket, cookbooks: cookbooks)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-6 px-20">
      <%= for cookbook <- assigns.cookbooks do %>
        <div class="p-6 shadow-md text-lg rounded font-bold">
          <a href={"/cookbook/#{cookbook.uuid}"}>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-6 h-6 inline"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M16.5 3.75V16.5L12 14.25 7.5 16.5V3.75m9 0H18A2.25 2.25 0 0120.25 6v12A2.25 2.25 0 0118 20.25H6A2.25 2.25 0 013.75 18V6A2.25 2.25 0 016 3.75h1.5m9 0h-9"
              />
            </svg>

            <span class="pl-4">
              <%= cookbook.name %>
            </span>
          </a>
        </div>
      <% end %>
    </div>
    """
  end
end
