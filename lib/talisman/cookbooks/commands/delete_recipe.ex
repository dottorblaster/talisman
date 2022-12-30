defmodule Talisman.Cookbooks.Commands.DeleteRecipe do
  @moduledoc """
  DeleteRecipe command
  """

  @required_fields :all

  use Talisman.Command

  defcommand do
    field :recipe_uuid, Ecto.UUID
    field :cookbook_uuid, Ecto.UUID
  end
end
