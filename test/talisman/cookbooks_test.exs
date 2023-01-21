defmodule Talisman.CookbooksTest do
  use Talisman.DataCase

  alias Talisman.Cookbooks

  describe "create a cookbook" do
    new_cookbook = %{author_uuid: Faker.UUID.v4(), name: Faker.Pokemon.name(), recipes: []}
    assert :ok = Cookbooks.create_cookbook(new_cookbook)
  end
end
