defmodule Talisman.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talisman.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        email: "some email",
        hashed_password: "some hashed_password",
        image: "some image",
        username: "some username"
      })
      |> Talisman.Accounts.create_user()

    user
  end
end
