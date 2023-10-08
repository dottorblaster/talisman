defmodule TalismanWeb.PageController do
  use TalismanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", error_message: nil)
  end
end
