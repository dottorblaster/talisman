defmodule TalismanWeb.NewCookbookLive do
  use TalismanWeb, :live_view

  alias Talisman.Cookbooks

  on_mount TalismanWeb.UserLiveAuth

  def mount(_params, _session, socket), do: {:ok, assign(socket, cookbook_name: "")}

  def render(assigns) do
    ~H"""
    <form class="">
      <input name="cookbook_name" phx-change="update_cookbook_name" value={assigns.cookbook_name} />
      <button type="button" phx-click="new_cookbook_submit">Submit</button>
    </form>
    """
  end

  def handle_event("update_cookbook_name", %{"cookbook_name" => cookbook_name}, socket) do
    {:noreply, assign(socket, cookbook_name: cookbook_name)}
  end

  def handle_event("new_cookbook_submit", _, socket) do
    %{assigns: %{cookbook_name: cookbook_name, current_user: %{id: user_id}}} = socket
    :ok = Cookbooks.create_cookbook(%{author_uuid: user_id, name: cookbook_name})
    {:noreply, push_navigate(socket, to: "/cookbooks")}
  end
end
