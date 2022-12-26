defmodule TalismanWeb.UserControllerTest do
  use TalismanWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
  end
end
