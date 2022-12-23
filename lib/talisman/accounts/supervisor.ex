defmodule Talisman.Accounts.Supervisor do
  use Supervisor

  alias Talisman.Accounts

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Accounts.Projectors.User
      ],
      strategy: :one_for_one
    )
  end
end
