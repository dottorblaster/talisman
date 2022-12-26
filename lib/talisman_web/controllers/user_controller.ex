defmodule TalismanWeb.UserController do
  use TalismanWeb, :controller

  alias Talisman.Accounts

  action_fallback TalismanWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
