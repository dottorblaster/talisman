defmodule Talisman.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Talisman.Repo,
      # Start the Telemetry supervisor
      TalismanWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Talisman.PubSub},
      # Start the Endpoint (http/https)
      TalismanWeb.Endpoint
      # Start a worker by calling: Talisman.Worker.start_link(arg)
      # {Talisman.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Talisman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TalismanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
