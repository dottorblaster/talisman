defmodule Talisman.Accounts.Aggregates.UserTest do
  use Talisman.AggregateCase, aggregate: Talisman.Accounts.Aggregates.User

  alias Talisman.Accounts.Commands.RegisterUser
  alias Talisman.Accounts.Events.UserRegistered

  describe "register user" do
    @tag :unit
    test "should succeed when valid" do
      user_uuid = UUID.uuid4()

      %RegisterUser{username: username, email: email, hashed_password: hashed_password} =
        register_user_command = build(:register_user_command, user_uuid: user_uuid)

      assert_events(register_user_command, [
        %UserRegistered{
          user_uuid: user_uuid,
          email: email,
          username: username,
          hashed_password: hashed_password
        }
      ])
    end
  end
end
