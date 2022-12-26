defmodule Talisman.AccountsTest do
  use Talisman.DataCase

  alias Talisman.Accounts

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      user = build(:user)
      assert :ok = Accounts.register_user(user)
    end

    test "should fail if username is already taken" do
      %{username: username} = user = build(:user)
      assert :ok = Accounts.register_user(user)

      :timer.sleep(2000)

      other_user = build(:user, username: username)
      assert {:error, :username_already_taken} = Accounts.register_user(other_user)
    end
  end
end
