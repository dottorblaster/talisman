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
    <span>
      <%= for cookbook <- assigns.cookbooks do %>
        <div>
          <a href={"/cookbook/#{cookbook.uuid}"}><%= cookbook.name %></a>
        </div>
      <% end %>
    </span>
    """
  end
end
