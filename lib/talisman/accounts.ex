defmodule Talisman.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Talisman.Repo

  alias Talisman.Accounts.Commands.RegisterUser
  alias Talisman.Accounts.ReadModels.User
  alias Talisman.Commanded

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Get an existing user by their username, or return `nil` if not registered
  """
  def user_by_username(username) do
    username
    |> String.downcase()
    |> User.by_username()
    |> Repo.one()
  end

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    case username_registered?(attrs.username) do
      true ->
        {:error, :username_already_taken}

      false ->
        attrs
        |> Map.put(:user_uuid, UUID.uuid4())
        |> RegisterUser.new!()
        |> Commanded.dispatch()
    end
  end

  defp username_registered?(username) do
    case user_by_username(username) do
      nil -> false
      _ -> true
    end
  end
end
