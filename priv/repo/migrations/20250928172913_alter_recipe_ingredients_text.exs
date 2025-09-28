defmodule Talisman.Repo.Migrations.AlterRecipeIngredientsText do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      modify :ingredients, {:array, :text}
    end
  end
end
