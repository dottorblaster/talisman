defmodule TalismanWeb.PageControllerTest do
  use TalismanWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Talisman!"
  end
end
