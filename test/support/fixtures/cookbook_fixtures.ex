defmodule Talisman.CookbookFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talisman.Cookbook` context.
  """

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        author_bio: "some author_bio",
        author_image: "some author_image",
        author_username: "some author_username",
        author_uuid: "some author_uuid",
        body: "some body",
        description: "some description",
        favorite_count: 42,
        ingredients: [],
        published_at: ~N[2022-12-25 11:51:00],
        slug: "some slug",
        title: "some title"
      })
      |> Talisman.Cookbook.create_recipe()

    recipe
  end
end
