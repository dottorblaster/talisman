defmodule Talisman.Repo do
  use Ecto.Repo,
    otp_app: :talisman,
    adapter: Ecto.Adapters.Postgres
end
