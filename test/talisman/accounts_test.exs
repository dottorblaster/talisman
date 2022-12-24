defmodule Talisman.AccountsTest do
  use Talisman.DataCase

  alias Talisman.Accounts

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      user_to_register = build(:user)
      assert :ok = Accounts.register_user(user_to_register)
    end
  end
end
