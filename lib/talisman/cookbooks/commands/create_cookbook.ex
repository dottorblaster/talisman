defmodule Talisman.Cookbooks.Commands.CreateCookbook do
  @moduledoc """
  CreateCookbook command
  """

  @required_fields :all

  use Talisman.Command

  defcommand do
    field :author_uuid, Ecto.UUID
    field :cookbook_uuid, Ecto.UUID
    field :name, :string
  end
end
