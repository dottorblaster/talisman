defmodule Talisman.Cookbooks.Projectors.Cookbook do
  @moduledoc """
  User projector
  """

  use Commanded.Projections.Ecto,
    name: "Cookbooks.Projectors.Cookbook",
    application: Talisman.Commanded,
    repo: Talisman.Repo,
    consistency: :strong

  alias Talisman.Cookbooks.Events.CookbookCreated
  alias Talisman.Cookbooks.ReadModels.Cookbook

  project(
    %CookbookCreated{
      cookbook_uuid: cookbook_uuid,
      author_uuid: author_uuid,
      name: name
    },
    fn multi ->
      Ecto.Multi.insert(multi, :cookbook, %Cookbook{
        uuid: cookbook_uuid,
        author_uuid: author_uuid,
        name: name,
        recipes: []
      })
    end
  )
end
