defmodule Talisman.EventStore do
  @moduledoc """
  The event store for Talisman.
  """

  use EventStore, otp_app: :talisman
end
