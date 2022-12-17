defmodule Talisman.Factory do
  @moduledoc """
  Factories for tests
  """
  use ExMachina

  def user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end
end
