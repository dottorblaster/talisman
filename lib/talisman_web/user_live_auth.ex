defmodule TalismanWeb.UserLiveAuth do
  @moduledoc """
  This module can be used through an `on_mount` clause in a target component.
  On mount it takes the user token and puts the user inside the liveview socket.
  """

  import Phoenix.Component
  import Phoenix.LiveView
  alias Talisman.Accounts

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    if socket.assigns.current_user.inserted_at do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/users/log_in")}
    end
  end
end
