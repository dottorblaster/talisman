defmodule Talisman.Factory do
  @moduledoc """
  Factories for tests
  """
  use ExMachina

  alias Talisman.Accounts.Commands.RegisterUser

  def user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  def register_user_command_factory do
    %RegisterUser{
      user_uuid: Faker.UUID.v4(),
      username: Faker.Pokemon.name() |> String.downcase(),
      email: Faker.Internet.email(),
      hashed_password: Faker.UUID.v4()
    }
  end
end
