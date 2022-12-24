defmodule Talisman.Accounts.Projectors.User do
  @moduledoc """
  User projector
  """

  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.User",
    application: Talisman.Commanded,
    repo: Talisman.Repo,
    consistency: :strong

  alias Talisman.Accounts.Events.UserRegistered
  alias Talisman.Accounts.ReadModels.User

  project(
    %UserRegistered{
      user_uuid: user_uuid,
      username: username,
      email: email,
      hashed_password: hashed_password
    },
    fn multi ->
      Ecto.Multi.insert(multi, :user, %User{
        uuid: user_uuid,
        username: username,
        email: email,
        hashed_password: hashed_password,
        bio: nil,
        image: nil
      })
    end
  )
end
