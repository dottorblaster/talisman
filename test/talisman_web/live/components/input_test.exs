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
             "<input class=\"p-3 rounded-lg border-gray-200 shadow-md text-sm\" name=\"#{name}\" value=\"#{value}\">"
  end

  test "merges classes" do
    name = Faker.StarWars.character()
    value = Faker.StarWars.character()
    class = Faker.Food.sushi() |> String.replace(" ", "") |> String.downcase()

    html =
      render_component(
        fn assigns ->
          ~H"""
          <Input.input class={@class} name={@name} value={@value} />
          """
        end,
        %{name: name, value: value, class: class}
      )

    assert html =~ class
  end
end
