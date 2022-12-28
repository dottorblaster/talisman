defmodule Talisman.Cookbook.Aggregates.Cookbook do
  @moduledoc """
  Cookbook aggregate
  """

  @required_fields :all

  use Talisman.Type

  deftype do
    field :uuid, Ecto.UUID
    field :name, :string
    embeds_many :recipes, Cookbook.Recipe
  end
end
