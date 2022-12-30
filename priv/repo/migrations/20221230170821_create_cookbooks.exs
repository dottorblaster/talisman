defmodule Talisman.Repo.Migrations.CreateCookbooks do
  use Ecto.Migration

  def change do
    create table(:cookbooks, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :author_uuid, :binary_id
      add :name, :string
      add :recipes, {:array, :map}

      timestamps()
    end
  end
end
