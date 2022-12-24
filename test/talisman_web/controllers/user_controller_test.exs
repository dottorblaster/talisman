defmodule TalismanWeb.UserControllerTest do
  use TalismanWeb.ConnCase

  import Talisman.Factory

  alias Talisman.Accounts

  def fixture(:user, attrs \\ []) do
    build(:user, attrs) |> Accounts.create_user()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
  end
end
