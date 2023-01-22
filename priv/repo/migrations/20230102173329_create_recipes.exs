defmodule Talisman.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :cookbook_uuid, :binary_id
      add :author_uuid, :binary_id
      add :recipe, :string
      add :like_count, :integer
      add :liked_by, {:array, :string}
      add :ingredients, {:array, :string}
      add :published_at, :naive_datetime
      add :slug, :string
      add :name, :string
      add :category, :string

      timestamps()
    end
  end
end
