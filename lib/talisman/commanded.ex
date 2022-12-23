defmodule Talisman.Commanded do
  use Commanded.Application, otp_app: :talisman

  router(Talisman.Router)
end
