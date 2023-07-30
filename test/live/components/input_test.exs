defmodule TalismanWeb.Components.InputTest do
  use TalismanWeb.ConnCase
  use Phoenix.Component

  import Phoenix.LiveViewTest

  alias TalismanWeb.Components.Input

  test "greets" do
    name = Faker.StarWars.character()
    value = Faker.StarWars.character()

    assert render_component(
             fn assigns ->
               ~H"""
               <Input.input name={@name} value={@value} />
               """
             end,
             %{name: name, value: value}
           ) ==
             "<input class=\"rounded-lg border-gray-200 p-3 text-sm\" name=\"#{name}\" value=\"#{value}\">"
  end
end
