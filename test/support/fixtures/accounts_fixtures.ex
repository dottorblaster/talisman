defmodule Talisman.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talisman.Accounts` context.
  """

  def unique_user_username,
    do:
      Faker.Person.name()
      |> String.downcase()
      |> String.replace(" ", "")
      |> String.replace(".", "")
      |> String.replace("'", "")

  def unique_user_email, do: Faker.Internet.email()
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      username: unique_user_username(),
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Talisman.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
