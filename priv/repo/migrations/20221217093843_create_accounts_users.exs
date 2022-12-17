defmodule Talisman.Repo.Migrations.CreateAccountsUsers do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :username, :string
      add :email, :string
      add :hashed_password, :string
      add :bio, :string
      add :image, :string

      timestamps()
    end
  end
end
