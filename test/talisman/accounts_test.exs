defmodule Talisman.AccountsTest do
  use Talisman.DataCase

  alias Talisman.Accounts
  alias Talisman.Accounts.ReadModels.User

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      user_to_register = build(:user)
      IO.inspect(user_to_register)
      assert {:ok, %User{} = user} = Accounts.register_user(user_to_register)

      assert user.bio == "some bio"
      assert user.email == "some email"
      assert user.hashed_password == "some hashed_password"
      assert user.image == "some image"
      assert user.username == "some username"
    end
  end
end
