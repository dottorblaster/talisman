defmodule Talisman.Commanded do
  @moduledoc """
  Talisman Commanded application.
  """

  use Commanded.Application, otp_app: :talisman

  router(Talisman.Router)
end
