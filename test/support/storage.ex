defmodule MyApp.Storage do
  @moduledoc """
  This module contains functions to reset the read state and the event store after each test
  """

  alias EventStore.Storage.Initializer
  alias Talisman.EventStore

  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    reset_eventstore()
    reset_readstore()
  end

  defp reset_eventstore do
    config = EventStore.config()

    {:ok, conn} = Postgrex.start_link(config)

    Initializer.reset!(conn, config)
  end

  defp reset_readstore do
    config = Application.get_env(:talisman, Talisman.Repo)

    {:ok, conn} = Postgrex.start_link(config)

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
      accounts_users,
      cookbook_recipes,
      cookbooks,
      recipes,
      projection_versions
    RESTART IDENTITY
    CASCADE;
    """
  end
end
