defmodule Talisman.Cookbooks.Commands.AddRecipe do
  @moduledoc """
  AddRecipe command
  """

  @required_fields :all

  use Talisman.Command

  defcommand do
    field :author_uuid, Ecto.UUID
    field :recipe, :string
    field :ingredients, {:array, :string}
    field :category, :string
  end
end
