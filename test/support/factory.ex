defmodule Talisman.Factory do
  @moduledoc """
  Factories for tests
  """
  use ExMachina

  alias Talisman.Accounts.Commands.RegisterUser

  alias Talisman.Cookbooks.Commands.{
    AddRecipe,
    CreateCookbook,
    DeleteRecipe,
    EditRecipe,
    LikeRecipe
  }

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
    RegisterUser.new!(%{
      user_uuid: Faker.UUID.v4(),
      username: Faker.Pokemon.name() |> String.downcase(),
      email: Faker.Internet.email(),
      hashed_password: Faker.UUID.v4()
    })
  end

  def add_recipe_command_factory do
    AddRecipe.new!(%{
      author_uuid: Faker.UUID.v4(),
      recipe_uuid: Faker.UUID.v4(),
      cookbook_uuid: Faker.UUID.v4(),
      recipe: Faker.Lorem.paragraphs() |> Enum.join("\n"),
      name: Faker.Lorem.words(3) |> Enum.join(" "),
      ingredients: [Faker.StarWars.character(), Faker.StarWars.planet()],
      category: Faker.Food.dish()
    })
  end

  def create_cookbook_command_factory do
    CreateCookbook.new!(%{
      author_uuid: Faker.UUID.v4(),
      cookbook_uuid: Faker.UUID.v4(),
      name: Faker.Lorem.words(3) |> Enum.join(" ")
    })
  end

  def delete_recipe_command_factory do
    DeleteRecipe.new!(%{cookbook_uuid: Faker.UUID.v4(), recipe_uuid: Faker.UUID.v4()})
  end

  def edit_recipe_command_factory do
    EditRecipe.new!(%{
      recipe_uuid: Faker.UUID.v4(),
      cookbook_uuid: Faker.UUID.v4(),
      recipe: Faker.Lorem.paragraphs() |> Enum.join("\n"),
      name: Faker.Lorem.words(3) |> Enum.join(" "),
      ingredients: [Faker.StarWars.character(), Faker.StarWars.planet()],
      category: Faker.Food.dish()
    })
  end

  def like_recipe_command_factory do
    LikeRecipe.new!(%{
      recipe_uuid: Faker.UUID.v4(),
      cookbook_uuid: Faker.UUID.v4(),
      like_author: Faker.Internet.email()
    })
  end
end
