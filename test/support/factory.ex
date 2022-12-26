defmodule Talisman.Factory do
  @moduledoc """
  Factories for tests
  """
  use ExMachina

  alias Talisman.Accounts.Commands.RegisterUser

  def user_factory do
    %{
      email: Faker.Internet.email(),
      username: Faker.Pokemon.name() |> String.downcase(),
      hashed_password: Faker.UUID.v4(),
      bio: Faker.Lorem.paragraph(),
      image: Faker.Internet.image_url()
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
