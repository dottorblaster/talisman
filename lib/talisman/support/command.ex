defmodule Talisman.Command do
  @moduledoc """
  Adds the macro `defcommand` which is used to define a new command.
  """

  import Talisman.Type, only: [deftype: 1]

  defmacro defcommand(block) do
    quote do
      deftype(unquote(block))
    end
  end

  defmacro __using__(_opts) do
    quote do
      use Talisman.Type
      import Talisman.Command, only: [defcommand: 1]
    end
  end
end
