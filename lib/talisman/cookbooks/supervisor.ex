defmodule Talisman.Cookbooks.Supervisor do
  @moduledoc """
  Talisman Cookbook supervisor.

  This supervisor acts as a supervisor for the cookbook context and embeds supervision logic for all the projectors.
  """

  use Supervisor

  alias Talisman.Cookbooks

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Cookbooks.Projectors.Recipe
      ],
      strategy: :one_for_one
    )
  end
end
