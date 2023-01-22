defmodule Talisman.AccountsTest do
  use Talisman.DataCase

  alias Talisman.Accounts
  alias Talisman.Accounts.ReadModels.User

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      %{username: username, email: email} = user = build(:user)
      assert :ok = Accounts.register_user(user)

      assert %User{username: ^username, email: ^email} =
               username |> User.by_username() |> Repo.one!()
    end

    test "should fail if username is already taken" do
      %{username: username} = user = build(:user)
      assert :ok = Accounts.register_user(user)

      other_user = build(:user, username: username)
      assert {:error, :username_already_taken} = Accounts.register_user(other_user)
    end
  end
end
